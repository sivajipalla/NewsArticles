//
//  CoreDataManager.swift
//  News Task
//
//  Created by Sivaji Palla on 24/09/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "NewsModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    func saveArticle(article: Article) {
        let context = persistentContainer.viewContext
        //Article Entity
        let articleEntity = ArticleEntity(context: context)
        articleEntity.title = article.title
        articleEntity.articleDescription = article.description
        articleEntity.publishedAt = article.publishedAt
        articleEntity.imageUrl = article.urlToImage
        articleEntity.url = article.url
        
        //Source Entity
        let sourceEntity = SourceEntity(context: context)
        sourceEntity.id = article.source.id
        sourceEntity.name = article.source.name
        
        //Set The Relationship
        articleEntity.source = sourceEntity
        
        //Save Context
        do {
            try context.save()
        } catch {
            print("Failed to save article: \(error)")
        }
    }
    
    func fetchArticles() -> [ArticleEntity] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch articles: \(error)")
            return []
        }
    }
}
