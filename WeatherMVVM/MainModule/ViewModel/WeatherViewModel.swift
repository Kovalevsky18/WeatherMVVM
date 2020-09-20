//
//  WeatherViewModel.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/16/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherViewModelProtocol {
    var updateWeatherData: ((WeatherData)->())? {get set}
    var updateCityWeatherData: ((WeatherCity)->())? {get set}
    func startFetch()
    func startCityFetch(city: String)
}

final class WeatherViewModel: WeatherViewModelProtocol {
    
    private let networkService: WeatherServiceProtocol = WeatherService()
    public var updateWeatherData: ((WeatherData) -> ())?
    public var updateCityWeatherData: ((WeatherCity) -> ())?
    
    init() {
        updateWeatherData?(.inital)
        updateCityWeatherData?(.inital)
    }
    
    func startFetch() {
        LocationManager.sharedInstance.getLocation { (location: CLLocation?, error: NSError?) in
            guard let locValue = location?.coordinate else {return}
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            self.networkService.fetchWeather(lat: locValue.latitude, long: locValue.longitude, success: { (data) in
                DispatchQueue.main.async {
                    self.updateWeatherData?(.success(WeatherData.Weather(timezone: data?.timezone, current: data?.current, daily: data?.daily)))
                }
            })
            { (error) in
                print(error)
            }
        }
    }
    
    func startCityFetch(city: String) {
        self.networkService.fetchCityWeather(city: city, success: { (data) in
            DispatchQueue.main.async {
                self.updateCityWeatherData?(.success(WeatherCity.CityWeather(list: data?.list, city: data?.city)))
            }
        })
        { (error) in
            print(error)
        }
    }
}
