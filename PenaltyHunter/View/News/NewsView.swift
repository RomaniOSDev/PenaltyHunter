//
//  NewsView.swift
//  PenaltyHunter
//
//  Created by Роман Главацкий on 27.08.2025.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject var navManager: NavigationManager
    @StateObject private var apiService = NewsAPIService.shared
    @State private var selectedCategory: NewsItem.NewsCategory? = nil
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            Image(.mainBack)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button {
                        navManager.popBack()
                    } label: {
                        Image(.backButton)
                            .resizable()
                            .frame(width: 70, height: 60)
                    }
                    
                    Spacer()
                    
                    Text("Football News")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(.backButton)
                        .resizable()
                        .frame(width: 70, height: 60)
                        .opacity(0)
                }
                .padding()
                
                // Search and Filter
                searchAndFilterView
                
                // News List
                newsListView
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            apiService.fetchAPIInfo()
        }
    }
    
    private var apiStatusView: some View {
        VStack(spacing: 10) {
            if let apiInfo = apiService.apiInfo {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("API Connected")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("SStats.net v\(apiInfo.version)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if let url = URL(string: apiInfo.mainSiteUrl) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.3))
                )
            } else if apiService.isLoading {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                    Text("Connecting to SStats.net API...")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.3))
                )
            } else if let errorMessage = apiService.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Connection Error")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        apiService.fetchAPIInfo()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.3))
                )
            }
        }
        .padding(.horizontal)
    }
    
    private var searchAndFilterView: some View {
        VStack(spacing: 15) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.6))
                
                TextField("Search news...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(.white)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black.opacity(0.3))
            )
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Button(action: { selectedCategory = nil }) {
                        HStack {
                            Text("All")
                            Text("\(filteredNews.count)")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.7))
                                )
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(selectedCategory == nil ? .white : .white.opacity(0.6))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedCategory == nil ? Color.blue : Color.blue.opacity(0.3))
                        )
                    }
                    
                    ForEach(NewsItem.NewsCategory.allCases, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            HStack {
                                Text(category.emoji)
                                Text(category.rawValue)
                                Text("\(categoryFilteredNews(for: category).count)")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(
                                        Circle()
                                            .fill(Color(category.color).opacity(0.7))
                                    )
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(selectedCategory == category ? .white : .white.opacity(0.6))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedCategory == category ? Color(category.color) : Color(category.color).opacity(0.3))
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
    
    private var newsListView: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                if filteredNews.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "newspaper")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("No news found")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Try adjusting your search or filter")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 50)
                } else {
                    ForEach(filteredNews) { newsItem in
                        NewsCard(newsItem: newsItem)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var filteredNews: [NewsItem] {
        let allNews = apiService.getNewsItems()
        var filtered = allNews
        
        // Apply category filter
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { news in
                news.title.localizedCaseInsensitiveContains(searchText) ||
                news.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    private func categoryFilteredNews(for category: NewsItem.NewsCategory) -> [NewsItem] {
        return apiService.getNewsItems().filter { $0.category == category }
    }
}

struct NewsCard: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(newsItem.category.emoji)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(newsItem.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text(newsItem.source)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Text(timeAgoString(from: newsItem.date))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            // Description
            Text(newsItem.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(3)
            
            // Category Badge
            HStack {
                Text(newsItem.category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(newsItem.category.color).opacity(0.7))
                    )
                
                Spacer()
                
                Button(action: {
                    // Share functionality could be added here
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.3))
        )
    }
    
    private func timeAgoString(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        switch interval {
        case 0..<3600:
            return "Just now"
        case 3600..<86400:
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        case 86400..<604800:
            let days = Int(interval / 86400)
            return "\(days)d ago"
        default:
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
    }
}

#Preview {
    NewsView()
        .environmentObject(NavigationManager())
}
