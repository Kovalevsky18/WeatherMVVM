//
//  ViewController.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import UIKit
import Framezilla

private enum Constants {
    static let insets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    static let fontSize: CGFloat = 30
    static let size = 44
}

class ViewController: UIViewController {
    
    private(set) lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "02d")
        return imageView
    }()
    
    private(set) lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: AppConfiguration.font,
                            size: Constants.fontSize)
        label.text = "Minsk,Belarus"
        return label
    }()
    
    private(set) lazy var temperatureLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: AppConfiguration.font,
                            size: Constants.fontSize)
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
        button.setAttributedTitle(title,
                                  for: .normal)
        button.addTarget(self,
                         action: #selector(shareButtonAction),
                         for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellClass(CollectionViewCell.self)
        return collectionView
    }()
    
    private(set) lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .large
        activityView.hidesWhenStopped = true
        activityView.color = .white
        activityView.isHidden = false
        return activityView
    }()
    
    private(set) lazy var blur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth,
                                           .flexibleHeight]
        return blurEffectView
    }()
    
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        return searchBar
    }()
    
    
    var data: WeatherData.Weather?
    
    private var viewModel: WeatherViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(imageView)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(shareButton)
        view.addSubview(collectionView)
        view.addSubview(blur)
        view.addSubview(activityView)
        viewModel = WeatherViewModel()
        viewModel?.startFetch()
        updateViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        searchBar.configureFrame { (maker) in
            maker.centerX()
            maker.top(inset: 30)
        }
        imageView.configureFrame { (maker) in
            maker.top(to: searchBar.nui_bottom, inset: 50)
            maker.centerX()
            maker.height(200)
            maker.width(130)
        }
        cityLabel.configureFrame { (maker) in
            maker.top(to: imageView.nui_bottom, inset: Constants.insets.top)
            maker.centerX()
            maker.width(200)
            maker.sizeToFit()
        }
        temperatureLabel.configureFrame { (maker) in
            maker.top(to: cityLabel.nui_bottom, inset: Constants.insets.top)
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
            maker.top(to: shareButton.nui_bottom, inset: Constants.insets.top)
            maker.width(view.bounds.width)
            maker.bottom(to: view.nui_bottom)
        }
        activityView.configureFrame { (maker) in
            maker.center()
            maker.height(Constants.size)
            maker.width(Constants.size)
        }
        blur.configureFrame { (maker) in
            maker.edges(insets: .zero)
        }
        
    }
    
    func updateViewModel() {
        viewModel?.updateWeatherData = { [weak self] data in
            switch data {
            case .inital:
                print("initial")
            case .loading:
                self?.activityView.startAnimating()
            case .success(let weatherData):
                self?.blur.isHidden = true
                self?.activityView.stopAnimating()
                
                self?.data = weatherData
                
                guard let icon = weatherData.current?.weather.first?.icon,
                    let temp = weatherData.current?.temp,
                    let tempInfo = weatherData.current?.weather.first?.main,
                    let city = weatherData.timezone
                    else { return }
                
                self?.imageView.image = UIImage(named: icon)
                self?.temperatureLabel.text =  "\(String(Int(temp)))°, " + tempInfo
                self?.cityLabel.text = city
                
                let shareText = "City: \(city)" +
                "\nTemperature: \(String(temp))°, \(tempInfo) "
                UserDefaults.standard.set(shareText, forKey: "shareText")
            }
            
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func shareButtonAction() {
        let text = UserDefaults.standard.value(forKey: "shareText")
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension ViewController: UISearchBarDelegate,UISearchDisplayDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else { return }
        print(city)
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
        
        guard let date = data?.daily?[indexPath.row].dt,
            let icon = data?.daily?[indexPath.row].weather.first?.icon,
            let temperature = data?.daily?[indexPath.row].temp.day
            else{ return cell }
        
        cell.imageView.image = UIImage(named: icon)
        cell.dateLabel.text = date.weekday()
        cell.temperatureLabel.text = String(describing: Int(temperature)) + "°"
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.5, height: collectionView.bounds.height * 0.8 )
    }
}
