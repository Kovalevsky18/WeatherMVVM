//
//  Weather.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

enum WeatherData {
    case inital
    case loading
    case success(Weather)
    
    // MARK: - Weather
    struct Weather: Codable {
        let timezone: String?
        let current: Current?
        let daily: [Daily]?
    }
}
