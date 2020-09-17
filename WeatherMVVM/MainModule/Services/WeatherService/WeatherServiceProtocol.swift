//
//  WeatherServiceProtocol.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

protocol  WeatherServiceProtocol: class {
    
    func fetchWeather(lat: Double, long: Double, success: @escaping (WeatherData.Weather?) -> Void,
                      failure: @escaping (Error) -> Void)
}
