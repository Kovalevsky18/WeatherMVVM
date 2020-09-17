//
//  WeatherEndpoint.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

enum WeatherEndpoint {
    case weather(lat: Double, long: Double)
}

enum PathEndpoint {
    case dictionary
}

extension WeatherEndpoint: Endpoint {
    
    var baseURL: URL {
        AppConfiguration.serverURL
    }
    
    var path: String {
        switch self {
        case .weather( _, _):
            return "data/2.5/onecall"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .weather(let lat, let long):
            return ["appid": AppConfiguration.apiKey,
                    "lat": "\(lat)",
                "lon": "\(long)",
                "exclude": "hourly",
                "units": "metric" ]
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : Any] {
        [:]
    }
    
    var parameterEncoding: ParameterEncoding {
        return .URLEncoding
    }
}
