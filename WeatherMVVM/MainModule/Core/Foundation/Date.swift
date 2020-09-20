//
//  Date.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/17/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

extension Int {
    
    func weekday() -> String {
        let newData = TimeInterval(self)
        let date = Date(timeIntervalSince1970: newData)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    func weekdayAndTime() -> String {
        let newData = TimeInterval(self)
        let date = Date(timeIntervalSince1970: newData)
        let formatter = DateFormatter()
        formatter.dateFormat = "EE HH:MM"
        return formatter.string(from: date)
    }
}
