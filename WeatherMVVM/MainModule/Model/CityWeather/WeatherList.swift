//
//  WeatherList.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/18/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

struct WeatherList: Codable {
    let dt: Int
    let main: Main
    let weather: [WeatherIcon]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}
