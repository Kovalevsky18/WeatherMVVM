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
    func startFetch()
}

final class WeatherViewModel: WeatherViewModelProtocol {
    
    private let networkService: WeatherServiceProtocol = WeatherService()
    public var updateWeatherData: ((WeatherData) -> ())?
    
    init() {
        updateWeatherData?(.inital)
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
                    self.updateWeatherData?(.success(WeatherData.Weather(timezone: data.unsafelyUnwrapped.timezone, current: data.unsafelyUnwrapped.current, daily: data.unsafelyUnwrapped.daily)))
                }
            })
            { (error) in
                print(error)
            }
        }
    }
    
    
}
