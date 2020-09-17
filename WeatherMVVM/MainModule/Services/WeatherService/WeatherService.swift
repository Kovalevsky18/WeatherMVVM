//
//  WeatherService.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

final class WeatherService: NetworkService, WeatherServiceProtocol {
    
    func fetchWeather(lat: Double,long: Double, success: @escaping (WeatherData.Weather?) -> Void,
                     failure: @escaping (Error) -> Void) {
        let endpoint: WeatherEndpoint = .weather(lat: lat, long: long)
        request(endpoint: endpoint, success: { (response: WeatherData.Weather) in
            success(response)
        }, failure: { (error) in
            failure(error)
        })
    }
}

