//
//  ListGameCell.swift
//  GameDB
//
//  Created by Hada Melino on 15/05/23.
//

import UIKit

class ListGameCell: UITableViewCell {
    
        // MARK: - UI Elements
    
    private lazy var imageGame: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var releaseDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ratingStar: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal))
        return imageView
    }()
        
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Variables
    
    static internal let identifier = "listGameCell"
    private let imageHandler = ImageHandler()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageHandler.cancelImageRequest()
        imageGame.image = nil
    }
    
    private func configureLayout() {
        contentView.addSubview(imageGame)
        imageGame.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, paddingTop: 10, paddingBottom: 10)
        imageGame.clipsToBounds = true
        imageGame.layer.cornerRadius = 12
        imageGame.widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        contentView.addSubview(title)
        title.anchor(top: contentView.topAnchor, left: imageGame.rightAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
        contentView.addSubview(releaseDate)
        releaseDate.anchor(top: title.bottomAnchor, left: title.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingRight: 10)
        
        contentView.addSubview(ratingStar)
        ratingStar.anchor(top: releaseDate.bottomAnchor, left: releaseDate.leftAnchor, paddingTop: 10)
        ratingStar.setDimensions(width: 20, height: 20)
        
        contentView.addSubview(ratingLabel)
        ratingLabel.anchor(top: ratingStar.topAnchor, left: ratingStar.rightAnchor, right: contentView.rightAnchor, paddingLeft: 5)
        ratingLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    internal func configureView(info: (name: String,
                       released: String,
                       rating: Float,
                       backgroundImageURL: String)) {
        title.text = info.name
        releaseDate.text = "Release date \(info.released)"
        ratingLabel.text = String(info.rating)
        addSpineer()
        imageHandler.imageDownloader(url: info.backgroundImageURL, downSampleTo: CGSize(width: 180, height: 200), cache: gameListCache) { image in
            DispatchQueue.main.async {
                self.imageGame.image = image
                self.spinner.removeFromSuperview()
            }
        }
    }
    
    internal func addSpineer() {
        imageGame.addSubview(spinner)
        spinner.center(inView: imageGame)
        spinner.startAnimating()
    }
    
}
