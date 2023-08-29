//
//  DetailViewController.swift
//  News
//
//  Created by Max Kuzmin on 29.08.2023.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    private var detail: Detail?
    private var publisher = ""
    private var isTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func fetchData(with article: Article) {
        NetworkManager.shared.jsonParsDetail(for: article.id) { detailData in
            DispatchQueue.main.async {
                self.publisher = article.publisher
                self.descriptionLabel.text = article.description
                self.configure(with: detailData)
            }
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold, width: .standard)
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular, width: .standard)
        return label
    }()
    
    private func createButton(imageName: String, action: Selector, title: String?) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .small
        configuration.buttonSize = .medium
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .systemGray6

        let button = UIButton(configuration: configuration)
        button.tintColor = .black
        button.setTitle(title, for: .normal)
        button.contentMode = .scaleAspectFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        return button
    }

    private lazy var likeButton: UIButton = {
        return createButton(imageName: "face.smiling", action: #selector(likeButtonTapped), title: "-")
    }()

    private lazy var dislikeButton: UIButton = {
        return createButton(imageName: "heart", action: #selector(dislikeButtonTapped), title: "-")
    }()

    private lazy var followingButton: UIButton = {
        return createButton(imageName: "star", action: #selector(followingTapped), title: "-")
    }()

    private lazy var commentButton: UIButton = {
        return createButton(imageName: "bubble.left", action: #selector(commentButtonTapped), title: "-")
    }()

    private lazy var shareButton: UIButton = {
        return createButton(imageName: "square.and.arrow.up", action: #selector(shareButtonTapped), title: nil)
    }()
}

private extension DetailViewController {
    func createNavBarButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.contentMode = .scaleAspectFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget (self, action: selector, for: .touchUpInside)
        button.setImage(UIImage (systemName: imageName)?.withRenderingMode (.alwaysTemplate), for: .normal)
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
    
    @objc func likeButtonTapped() {
        if isTapped {
            isTapped = false
            likeButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        } else {
            isTapped = true
            likeButton.setImage(UIImage(systemName: "face.smiling.fill"), for: .normal)
        }
    }
    
    @objc func dislikeButtonTapped() {
        
    }
    
    @objc func followingTapped() {
        
    }
    
    @objc func commentButtonTapped() {
        
    }
    
    @objc func shareButtonTapped() {
        
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func setNumber(for button: UIButton, number: Int, to fontSize: CGFloat) {
        if number >= 10 {
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        button.titleLabel?.text = "\(number)"
    }
    
    func configure(with detail: Detail) {
        textLabel.text = detail.text
        setNumber(for: likeButton, number: detail.like, to: 12)
        setNumber(for: dislikeButton, number: detail.dislike, to: 12)
        setNumber(for: followingButton, number: detail.following, to: 12)
        setNumber(for: commentButton, number: detail.comment, to: 12)
 
        let newsUrl = detail.image
        let publisherUrl = publisher
        Task {
            do {
                let newsImage = try await loadImage(url: newsUrl)
                let publisherImage = try await loadImage(url: publisherUrl)
                self.imageView.image = publisherImage
                self.image.image = newsImage
            } catch {
                print(error)
                self.image.image = UIImage(named: "3")
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
    
    func configureView() {
        view.backgroundColor = .white
        
        let shareBarButton = createNavBarButton(imageName: "square.and.arrow.up", selector: #selector(shareButtonTapped))
        let phoneBarButton = createNavBarButton(imageName: "ellipsis.message", selector: #selector(shareButtonTapped))
        let commentBarButton = createNavBarButton(imageName: "bubble.left", selector: #selector(commentButtonTapped))
        let backBarButton = createNavBarButton(imageName: "arrow.backward", selector: #selector(backButtonTapped))
        
        var space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 10
        
        // Установка элементов в правой части навигационной панели
        navigationItem.rightBarButtonItems = [shareBarButton, space, phoneBarButton, space, commentBarButton]
        // Установка элемента в левой части навигационной панели
        navigationItem.leftBarButtonItem = backBarButton
        // Установка элемета в title навигационной панели
        navigationItem.titleView = imageView
        navigationItem.titleView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(image)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(dislikeButton)
        contentView.addSubview(followingButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        layout(in: contentView)
    }
    
    func layout(in contentView: UIView) {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            image.heightAnchor.constraint(equalToConstant: 250),
            
            descriptionLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            likeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            likeButton.widthAnchor.constraint(equalToConstant: 60),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            dislikeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            dislikeButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 13),
            dislikeButton.widthAnchor.constraint(equalToConstant: 60),
            dislikeButton.heightAnchor.constraint(equalToConstant: 40),
            
            followingButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            followingButton.leadingAnchor.constraint(equalTo: dislikeButton.trailingAnchor, constant: 13),
            followingButton.widthAnchor.constraint(equalToConstant: 60),
            followingButton.heightAnchor.constraint(equalToConstant: 40),
            
            commentButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            commentButton.leadingAnchor.constraint(equalTo: followingButton.trailingAnchor, constant: 13),
            commentButton.widthAnchor.constraint(equalToConstant: 60),
            commentButton.heightAnchor.constraint(equalToConstant: 40),
            
            shareButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            shareButton.widthAnchor.constraint(equalToConstant: 60),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            
            textLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 15),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
        
        if UIScreen.main.bounds.height <= 1224 {
            // 50/50?
            likeButton.configuration?.buttonSize = .small
            dislikeButton.configuration?.buttonSize = .small
            followingButton.configuration?.buttonSize = .small
            commentButton.configuration?.buttonSize = .small
            shareButton.configuration?.buttonSize = .small
            
            NSLayoutConstraint.activate([
                likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                dislikeButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 9),
                followingButton.leadingAnchor.constraint(equalTo: dislikeButton.trailingAnchor, constant: 9),
                commentButton.leadingAnchor.constraint(equalTo: followingButton.trailingAnchor, constant: 9),
                shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
        }
    }
}
