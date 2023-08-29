//
//  TodayViewController.swift
//  News
//
//  Created by Max Kuzmin on 28.08.2023.
//

import UIKit

class TodayViewController: UIViewController {
    
    private let detailViewController = DetailViewController()
    private let collectionInsets = UIEdgeInsets(top: 8, left: 5, bottom: 5, right: 0)
    private var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        fetchData()
    }
    
    private func fetchData() {
        NetworkManager.shared.jsonParsArticle { articleData in
            DispatchQueue.main.async {
                self.articles = articleData
                self.collectionView.reloadData()
            }
        }
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 355, height: 130)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TodayColleсtionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "More For You"
        label.font = .systemFont(ofSize: 32, weight: .heavy, width: .standard)
        return label
    }()
}

private extension TodayViewController {
    func configureView() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
    }
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TodayColleсtionViewCell else { return UICollectionViewCell() }
        
        let article = articles[indexPath.item]
        cell.configure(with: article)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = articles[indexPath.item]
        detailViewController.fetchData(with: article)
        //collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
