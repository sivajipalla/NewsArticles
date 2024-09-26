//
//  NewsViewModel.swift
//  News Task
//
//  Created by Sivaji Palla on 24/09/24.
//

import Foundation
import Combine

class NewsViewModel : ObservableObject {
    @Published var newsArticles: [ArticleEntity] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let newsService = NewsAPIService()
    private let coreDataManager = CoreDataManager.shared
    
    func fetchNews() {
        newsService.fetchNews()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching news: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] fetchedArticles in
                fetchedArticles.forEach { article in
                    //Save Articles Into Core Data
                    self?.coreDataManager.saveArticle(article: article)
                }
                //Fetch Saved Articles From Core Data
                self?.newsArticles = self?.coreDataManager.fetchArticles() ?? []
            }
            .store(in: &cancellables)
    }
}
