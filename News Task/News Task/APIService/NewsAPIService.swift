//
//  NewsAPIService.swift
//  News Task
//
//  Created by Sivaji Palla on 24/09/24.
//

import Foundation
import Combine

class NewsAPIService {
    private var cancellable: AnyCancellable?
    
    func fetchNews() -> AnyPublisher<[Article], Error> {
        let urlString = "https://newsapi.org/v2/everything?q=apple&from=2024-09-23&to=2024-09-23&sortBy=popularity&apiKey=bae2da441e0641268278549db9762eca"
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ArticleResponse.self, decoder: JSONDecoder())
            .map { $0.articles }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

