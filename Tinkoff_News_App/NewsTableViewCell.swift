//
//  TableViewCell.swift
//  Tinkoff_News_App
//
//  Created by Софья Норина on 3.02.2023.
//

import UIKit

class NewsTableViewCellModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    let date: String?
    
    init(title: String, subtitle: String, imageURL: URL?, date: String?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.date = date
    }
}

class NewsTableViewCell: UITableViewCell {
    static let id = "NewsTableViewCell"

    
    private let dateOfNews: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 5, weight: .light)
        return label
    }()
    
    private let titleOfNewsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let subTitleOfNEws: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let imageNewsView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateOfNews)
        contentView.addSubview(titleOfNewsLabel)
        contentView.addSubview(subTitleOfNEws)
        contentView.addSubview(imageNewsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        titleOfNewsLabel.frame = CGRect(
                    x: 10,
                    y: 0,
                    width: contentView.frame.size.width - 10,
                    height: 45
        )
        imageNewsView.frame = CGRect(
                   x: 40,
                   y: 50,
                   width: 300,
                   height: 130
                   
                   
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleOfNewsLabel.text = nil
        subTitleOfNEws.text = nil
        imageNewsView.image = nil
    }
    func configure(with viewModel: NewsTableViewCellModel ){
        titleOfNewsLabel.text = viewModel.title
        subTitleOfNEws.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            imageNewsView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL{
            URLSession.shared.dataTask(with: url){ [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.imageNewsView.image = UIImage(data: data)
                }
            } .resume()
        }
    }
}
