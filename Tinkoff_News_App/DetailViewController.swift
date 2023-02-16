//
//  NewsViewController.swift
//  Tinkoff_News_App
//
//  Created by Софья Норина on 4.02.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var URLButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
   
    var imageData: Data? = nil
    var imageURL = URL(string: "")
    var newsTitle = ""
    var newsSource = ""
    var newsDate = ""
    var newsDesc = ""
    var newsURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        titleLabel.numberOfLines = 0
        titleLabel.font = titleLabel.font.withSize(24)
        titleLabel.text = newsTitle
        
        authorLabel.text = newsSource
        
        descriptionText.text = newsDesc
        descriptionText.isEditable = false
        dateLabel.text = " "
        dateLabel.text = String(newsDate.prefix(upTo: newsDate.index(newsDate.startIndex, offsetBy: 10)))
//
        // News Image
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: self!.imageURL!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.imageView.image = image
                            }
                        }
                    }
                }
        
        //Button
        URLButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    @objc private func didTapButton(){
        guard let url = URL(string: newsURL) else { return }
        let vc = WebViewController(url: url, title: "Sours")
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
}

