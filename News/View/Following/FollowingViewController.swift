//
//  FollowingViewController.swift
//  News
//
//  Created by Max Kuzmin on 28.08.2023.
//

import UIKit

class FollowingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

private extension FollowingViewController {
    func configureView() {
        view.backgroundColor = .white
        title = "Following"
        
        layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
