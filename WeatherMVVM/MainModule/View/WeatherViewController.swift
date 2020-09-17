//
//  ViewController.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import UIKit
import Framezilla

class ViewController: UIViewController {
    
    private(set) lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "02d")
        return imageView
    }()
    
    private(set) lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir LT 55 Roman", size: 30)
        label.text = "Minsk,Belarus"
        return label
    }()
    
    private(set) lazy var temperatureLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir LT 55 Roman", size: 30)
        label.textColor = .blue
        label.text = "22°, sunny"
        return label
    }()
    
    private(set) lazy var shareButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .white
        let titleValue = "Share"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.orange ]
        let title = NSAttributedString(string: titleValue,
                                       attributes: attributes)
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellClass(CollectionViewCell.self)
        return collectionView
    }()
    
    var data: WeatherData.Weather?
    
    private var viewModel: WeatherViewModelProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(shareButton)
        view.addSubview(collectionView)
        viewModel = WeatherViewModel()
        viewModel?.startFetch()
        updateViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        imageView.configureFrame { (maker) in
            maker.top(inset: 50)
            maker.centerX()
            maker.height(200)
            maker.width(130)
            maker.sizeToFit()
        }
        cityLabel.configureFrame { (maker) in
            maker.top(to: imageView.nui_bottom, inset: 10)
            maker.centerX()
            maker.width(200)
            maker.sizeToFit()
        }
        temperatureLabel.configureFrame { (maker) in
            maker.top(to: cityLabel.nui_bottom, inset: 10)
            maker.centerX()
            maker.width(200)
            maker.sizeToFit()
        }
        shareButton.configureFrame { (maker) in
            maker.top(to: temperatureLabel.nui_bottom,inset: 40)
            maker.centerX()
            maker.width(200)
            maker.sizeToFit()
        }
        collectionView.configureFrame { (maker) in
            maker.top(to: shareButton.nui_bottom, inset: 10)
            maker.width(view.bounds.width)
            maker.bottom(to: view.nui_bottom)
        }
    }
    
    func updateViewModel() {
        viewModel?.updateWeatherData = { [weak self] data in
            switch data {
            case .inital:
                print("initial")
            case .loading:
                //activity indicator
                print("loading")
            case .success(let weatherData):
                self?.data = weatherData
                self?.imageView.image = UIImage(named: weatherData.current?.weather.first?.icon ?? "")
                self?.temperatureLabel.text =  "\(String(Int(weatherData.current!.temp)))°, " +  (weatherData.current?.weather.first!.main ?? "")
                self?.cityLabel.text = weatherData.timezone
            }
            
            self?.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cellCount = data?.daily?.count {
            return cellCount
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let daily = data?.daily else { return cell }
        
        guard let date = data?.daily?[indexPath.row].dt,
            let icon = data?.daily?[indexPath.row].weather.first?.icon,
            let temperature = data?.daily?[indexPath.row].temp.day
            else{ return cell }
        
        var weekday: String {
            let newData = TimeInterval(date)
            let date = Date(timeIntervalSince1970: newData)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
        
        cell.imageView.image = UIImage(named: icon)
        cell.dateLabel.text = String(weekday)
        cell.temperatureLabel.text = String(describing: Int(temperature)) + "°"
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.5, height: collectionView.bounds.height * 0.8 )
    }
}
