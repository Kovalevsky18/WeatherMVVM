//
//  AppConfig.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

enum AppConfiguration {
    
    private enum Paths {
        static let api = "data"
    }
    
    static let serverURL = URL(string: "https://api.openweathermap.org")!
    static let apiKey = "a632e471f0b9c0c8bb09710584a6c1cc"
    static let font = "Avenir LT 55 Roman"
}
