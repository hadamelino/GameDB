//
//  DetailGameViewController.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import UIKit

class DetailGameViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var gameDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var favoriteImage: UIImage = {
        guard let image = UIImage(systemName: "heart.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal) else { return UIImage() }
        return image
    }()
    
    private lazy var navigationBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "AccentColor")
        return view
    }()
    
    private lazy var spinner = UIActivityIndicatorView(style: .large)

    // MARK: - Variables
    
    internal let viewModel: DetailGameViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.loadDetail()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkDetailIsFavorite()
        adjustFavoriteButtonImage()
    }
    
    required init(viewModel: DetailGameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        title = "Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        view.addSubview(gameDetailTableView)
        gameDetailTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(spinner)
        spinner.backgroundColor = .white
        spinner.addConstraintsToFillView(view)
        
        view.addSubview(navigationBackground)
        navigationBackground.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: gameDetailTableView.topAnchor, right: view.rightAnchor)
        
        let favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    @objc private func favoriteButtonTapped() {
        viewModel.toggleIsFavorite()
        adjustFavoriteButtonImage()
    }
     
    private func adjustFavoriteButtonImage() {
        navigationItem.rightBarButtonItem?.image = viewModel.getIsFavorite() ? favoriteImage.withTintColor(.red, renderingMode: .alwaysOriginal) : favoriteImage.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
}

extension DetailGameViewController: ViewModelOutput {
    func updateView(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .idle:
                break
            case .loading:
                self?.spinner.startAnimating()
            case .success:
                self?.viewModel.checkDetailIsFavorite()
                self?.adjustFavoriteButtonImage()
                self?.gameDetailTableView.reloadData()
                self?.spinner.stopAnimating()
            case .error(let error):
                self?.spinner.stopAnimating()
                print("error /n \(error)")
            }
        }
    }
}

extension DetailGameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier) as! DetailTableViewCell
        cell.configureView(info: viewModel.getDetailInfo())
        return cell
    }
    
}

