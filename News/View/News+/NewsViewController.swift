//
//  NewsViewController.swift
//  News
//
//  Created by Max Kuzmin on 28.08.2023.
//

import UIKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

private extension NewsViewController {
    func configureView() {
        view.backgroundColor = .white
        title = "News"
        
        layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
