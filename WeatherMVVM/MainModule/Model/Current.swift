//
//  Current.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

// MARK: - Current 
struct Current: Codable {
    let temp: Double 
    let weather: [CurrentWeather]
}
