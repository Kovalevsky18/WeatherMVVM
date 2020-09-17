//
//  CollectionViewCell.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private(set) lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Saturday"
        return label
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "11d")
        return imageView
    }()
    
    private(set) lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "17°"
        return label
    }()
        
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubview(dateLabel)
        addSubview(imageView)
        addSubview(temperatureLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.configureFrame { (maker) in
            maker.top(inset: 10)
            maker.centerX()
            maker.sizeToFit()
        }
        imageView.configureFrame { (maker) in
            maker.center()
            maker.sizeToFit()
        }
        temperatureLabel.configureFrame { (maker) in
            maker.bottom(inset: 10)
            maker.centerX()
            maker.sizeToFit()
        }
    }
}
