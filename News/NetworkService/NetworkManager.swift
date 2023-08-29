//
//  NetworkManager.swift
//  News
//
//  Created by Max Kuzmin on 28.08.2023.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let articleURL = "https://www.jsonkeeper.com/b/D3XE"
    private let newsURL = "https://www.jsonkeeper.com/b/0WER"
    
    func jsonParsArticle(compeletionHandler: @escaping ([Article]) -> Void) {
        guard let url = URL(string: articleURL) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else { return }
            do {
                let articleData = try JSONDecoder().decode(ArticlesResponse.self, from: data)
                compeletionHandler(articleData.articles)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func jsonParsDetail(for newsId: Int, compeletionHandler: @escaping (Detail) -> Void) {
        guard let url = URL(string: newsURL) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else { return }
            do {
                let detailData = try JSONDecoder().decode(DetailResponse.self, from: data)
                if let details = detailData.detail.first(where: { $0.id == newsId }) {
                    compeletionHandler(details)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
