//
//  Endpoint.swift
//  WeatherMVVM
//
//  Created by Родион Ковалевский on 9/14/20.
//  Copyright © 2020 Родион Ковалевский. All rights reserved.
//

import Foundation

typealias Parameters = [String:Any]

enum ParameterEncoding {
    case URLEncoding, JSONEncoding
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: [String: Any] { get }
    var parameterEncoding: ParameterEncoding { get }
}

extension Endpoint {
    var url: URL {
        baseURL.appendingPathComponent(path)
    }
}

enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
}
