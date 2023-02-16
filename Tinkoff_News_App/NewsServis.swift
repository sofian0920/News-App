//
//  NewsServis.swift
//  Tinkoff_News_App
//
//  Created by Софья Норина on 3.02.2023.
//

import Foundation
import UIKit


final class NewsServis {
    static let shared = NewsServis()
    
    struct Constants{
        static let mainHadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=de&category=business&apiKey=0fcc9fdba4094dfd8c9345063e72e78a")
    }
    private init() {}
    
    public func getTopHeadline(pagination: Bool = false ,complition: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.mainHadlinesURL else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                complition(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(servisResponse.self , from: data)
                    print("Articles: \(result.articles.count)")
                    complition(.success(result.articles))
                } catch {
                    complition(.failure(error))
                }
            }
        }
        task.resume()
    }
}



struct servisResponse: Codable {
    let articles: [Article]
}


struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct Source: Codable {
    let name: String
    
}

