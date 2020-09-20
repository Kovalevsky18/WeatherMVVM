//
//  CollectionViewCell.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import UIKit

private enum Constants {
    static let insets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    static let fontSize: CGFloat = 25
}

class CollectionViewCell: UICollectionViewCell {
    
    private(set) lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppConfiguration.font,
                            size: Constants.fontSize)
        label.textAlignment = .center
        label.text = "Saturday"
        return label
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "11d")
        return imageView
    }()
    
    private(set) lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppConfiguration.font,
                            size: Constants.fontSize)
        label.textAlignment = .center
        label.textColor = .blue
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
            maker.top(inset: Constants.insets.top)
            maker.centerX()
            maker.width(150)
            maker.sizeToFit()
        }
        imageView.configureFrame { (maker) in
            maker.center()
            maker.height(100)
            maker.width(80)
        }
        temperatureLabel.configureFrame { (maker) in
            maker.bottom(inset: Constants.insets.bottom)
            maker.width(100)
            maker.centerX()
            maker.sizeToFit()
        }
    }
}
