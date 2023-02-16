//
//  ViewController.swift
//  Tinkoff_News_App
//
//  Created by Софья Норина on 3.02.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let cache = NSCache<NSString, NewsTableViewCell>()
    
    private var refreshControl = UIRefreshControl()
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.id)
        return table
    }()
    private var viewModels = [NewsTableViewCellModel]()
    private var articles = [Article]()
    private var sources = [Source]()
    
    
    var detailImageURL = URL(string: "")
    var detailNewsTitle = ""
    var detailNewsSource = ""
    var detailNewsDate = ""
    var detailNewsDesc = ""
    var detailNewsURL = ""
    @IBAction func refreshButtonTapped(_ sender: Any) {
    }
        
    override func viewDidLoad() {
         
        super.viewDidLoad()
        title = "Today News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        NewsServis.shared.getTopHeadline { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellModel(title: $0.title, subtitle: $0.description ?? "No description", imageURL: URL(string: $0.urlToImage ?? ""), date: $0.publishedAt ?? "")
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
     
    @objc private func refreshData(){
      
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = "\(indexPath.section)_\(indexPath.row)" as NSString
        if let cachedCell = cache.object(forKey: key) {
            return cachedCell
        }
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.id, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        _ = indexPath.row
        
        let article = articles[indexPath.row]

        detailNewsTitle = article.title
        detailImageURL = URL(string: article.urlToImage ?? "Изображение отсутствует")
        detailNewsDesc = article.description ?? "Описания нет"
        detailNewsDate = article.publishedAt ?? ""
        detailNewsURL = article.url!
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToDetails", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let destination = segue.destination as! DetailViewController
            destination.imageURL = detailImageURL
            destination.newsTitle = detailNewsTitle
            destination.newsDate = detailNewsDate
            destination.newsDesc = detailNewsDesc
            destination.newsURL = detailNewsURL
        }
    }
        }
            
    
