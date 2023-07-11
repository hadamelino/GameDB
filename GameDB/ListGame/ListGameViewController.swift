//
//  ViewController.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import UIKit

class ListGameViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var gameListTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListGameCell.self, forCellReuseIdentifier: ListGameCell.identifier)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var navigationBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "AccentColor")
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private lazy var spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Variables
    
    private let viewModel: ListGameViewModel
    private let client = API.Client.shared
    private var searchTask: DispatchWorkItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadGameList()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    required init(viewModel: ListGameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.topItem?.title = "Games for You"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(navigationBackground)
        navigationBackground.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: searchBar.topAnchor, right: view.rightAnchor)
        
        view.addSubview(gameListTableView)
        gameListTableView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        gameListTableView.addSubview(spinner)
        spinner.center(inView: gameListTableView)
        
        gameListTableView.addSubview(errorLabel)
        errorLabel.center(inView: gameListTableView)
    }
    
}

extension ListGameViewController: ViewModelOutput {
    internal func updateView(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .idle:
                self?.gameListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            case .loading:
                self?.spinner.startAnimating()
            case .success:
                self?.spinner.stopAnimating()
                self?.gameListTableView.reloadData()
            case .error(let error):
                self?.spinner.stopAnimating()
                self?.gameListTableView.reloadData()
                self?.errorLabel.text = (error as! API.Types.CustomError).rawValue
            }
        }
    }
}

extension ListGameViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfData()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListGameCell.identifier) as! ListGameCell
        cell.configureView(info: viewModel.getInfo(for: indexPath))
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailGameViewModel = DetailGameViewModel(id: viewModel.getID(for: indexPath))
        navigationController?.pushViewController(DetailGameViewController(viewModel: detailGameViewModel), animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.paginate(indexPath: indexPath)
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}

extension ListGameViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.searchGame(searchQuery: searchText)
        }
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }

}
