//
//  CityWeather.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/18/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

enum WeatherCity {
    case inital
    case loading
    case success(CityWeather)
    
    struct CityWeather: Codable {
        let list: [WeatherList]
        let city: City
    }
}
