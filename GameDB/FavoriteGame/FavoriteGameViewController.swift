//
//  FavoriteGameViewController.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import UIKit

class FavoriteGameViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var favoriteGameTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListGameCell.self, forCellReuseIdentifier: ListGameCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var navigationBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "AccentColor")
        return view
    }()
    
    private let viewModel: FavoriteGameViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteGame()
    }
    
    init(viewModel: FavoriteGameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Favorite Games"
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addSubview(favoriteGameTableView)
        favoriteGameTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(navigationBackground)
        navigationBackground.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: favoriteGameTableView.topAnchor, right: view.rightAnchor)
    }
    
}

extension FavoriteGameViewController: ViewModelOutput {
    func updateView(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .idle:
                break
            case .loading:
                break
            case .success:
                self?.favoriteGameTableView.reloadData()
            case .error:
                break
            }
        }
    }
}

extension FavoriteGameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFavoriteGames
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListGameCell.identifier) as! ListGameCell
        cell.configureView(info: viewModel.getInfo(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteGame(for: indexPath)
            viewModel.fetchFavoriteGame()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailGameViewModel = DetailGameViewModel(id: viewModel.getID(for: indexPath))
        navigationController?.pushViewController(DetailGameViewController(viewModel: detailGameViewModel), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
