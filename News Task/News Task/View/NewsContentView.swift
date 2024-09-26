//
//  ContentView.swift
//  News Task
//
//  Created by Sivaji Palla on 24/09/24.
//

import SwiftUI
import CoreData
import Combine

struct NewsContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.newsArticles) { article in
                        //Show Artciels on News Card View
                        NewsCardView(articleEntity: article)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                }
            }
            .navigationTitle("News")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}

//MARK: NEWS CARD VIEW
struct NewsCardView: View {
    var articleEntity: ArticleEntity
       // ISO 8601 Date Formatter for the input format
       let isoFormatter: ISO8601DateFormatter = {
           let formatter = ISO8601DateFormatter()
           formatter.formatOptions = [.withInternetDateTime]
           return formatter
       }()

       // Formatter to display the date in a readable format
       let displayFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .none
           return formatter
       }()
    
    var body: some View {
        VStack(alignment: .leading) {
            //NEWS IMAGE
            if let imageUrl = articleEntity.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 100, height: 100)
                    } else {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                //NEWS TITLE
                Text(articleEntity.title ?? "No Title")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                //NEWS PUBLISHED DATE
                if let publishedDate = articleEntity.publishedAt {
                    if let date = isoFormatter.date(from: publishedDate) {
                        Text("Published on: \(displayFormatter.string(from: date))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                //NEWS DESCRIPTION
                Text(articleEntity.articleDescription ?? "No Description")
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .foregroundColor(Color(.sRGB, red: 0.2, green: 0.2, blue: 0.2, opacity: 1.0))
                    .lineLimit(3)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.bottom, 10)
    }
}
