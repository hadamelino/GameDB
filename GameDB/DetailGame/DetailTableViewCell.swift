//
//  DetailTableViewCell.swift
//  GameDB
//
//  Created by Hada Melino on 16/05/23.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
        
    // MARK: - UI Elements

    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var creatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var releaseDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
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
    
    private lazy var playtimeLogo: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "gamecontroller")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal))
        return imageView
    }()
    
    private lazy var playtimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    internal static let identifier = "detailCell"
    private let imageHandler = ImageHandler()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        backgroundImage.image = nil
        imageHandler.cancelImageRequest()
    }
    
    private func configureLayout() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(backgroundImage)
        backgroundImage.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
        backgroundImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        contentView.addSubview(creatorLabel)
        creatorLabel.anchor(top: backgroundImage.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: creatorLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        contentView.addSubview(releaseDate)
        releaseDate.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        contentView.addSubview(ratingStar)
        ratingStar.anchor(top: releaseDate.bottomAnchor, left: contentView.leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        contentView.addSubview(ratingLabel)
        ratingLabel.anchor(top: releaseDate.bottomAnchor, left: ratingStar.rightAnchor, paddingTop: 10, paddingLeft: 5)

        contentView.addSubview(playtimeLogo)
        playtimeLogo.anchor(top: releaseDate.bottomAnchor, left: ratingLabel.rightAnchor, paddingTop: 10, paddingLeft: 10)
        
        contentView.addSubview(playtimeLabel)
        playtimeLabel.anchor(top: releaseDate.bottomAnchor, left: playtimeLogo.rightAnchor, paddingTop: 10, paddingLeft: 5)
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: playtimeLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    }
    
    internal func configureView(info: Detail) {
        if let url = info.backgroundImageURL {
            imageHandler.imageDownloader(url: url, downSampleTo: CGSize(width: contentView.frame.size.width, height: 200), cache: detailGameCache) { image in
                DispatchQueue.main.async {
                    self.backgroundImage.image = image
                }
            }
        }
        
        creatorLabel.text = "Rockstar Games"
        titleLabel.text = info.name
        releaseDate.text = "Release date \(info.released ?? "")"
        ratingLabel.text = String(info.rating ?? 0)
        playtimeLabel.text = String(info.playtime ?? 0)
        var description = info.description?.replacingOccurrences(of: "<p>", with: "")
        description = description?.replacingOccurrences(of: "</p>", with: "")
        description = description?.replacingOccurrences(of: "<br />", with: "\n")
        descriptionLabel.text = description
    }
    
}
