//
//  TodayColletionViewCell.swift
//  News
//
//  Created by Max Kuzmin on 28.08.2023.
//

import UIKit
import Nuke

class TodayColleсtionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let publisherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 14, weight: .heavy, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let publishedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with article: Article) {
        descriptionLabel.text = article.description
        //publishedLabel.text = article.publishedAt
        publishedLabel.text = "1h ago"
        let publisherURL = article.publisher
        let newsURL = article.image
        Task {
            do {
                let publisherImage = try await loadImage(url: publisherURL)
                let newsImage = try await loadImage(url: newsURL)
                self.publisherImage.image = publisherImage
                self.newsImage.image = newsImage
            } catch {
                print(error)
                self.publisherImage.image = UIImage(named: "3")
            }
        }
    }
    
    func loadImage(url: String) async throws -> UIImage {
        let task = Task.init(priority: .high) {
            let task = ImagePipeline.shared.imageTask(with: URL(string: url)!)
            for await progress in task.progress {
                print("Updated progress: ", progress)
            }
            return try await task.image
        }
        return try await task.value
    }
}

// MARK: - Layout
private extension TodayColleсtionViewCell {
    func configureView() {
        contentView.addSubview(publisherImage)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(publishedLabel)
        contentView.addSubview(newsImage)
        layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            publisherImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            publisherImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            publisherImage.widthAnchor.constraint(equalToConstant: 90),
            publisherImage.heightAnchor.constraint(equalToConstant: 25),
            
            descriptionLabel.topAnchor.constraint(equalTo: publisherImage.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 220),
            
            publishedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            publishedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            
            newsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            newsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            newsImage.widthAnchor.constraint(equalToConstant: 130),
            newsImage.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
}
