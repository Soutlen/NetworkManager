//
//  Location.swift
//  NetworkManager
//
//  Created by Евгений Глоба on 12/8/24.
//

import Foundation

struct LocationAPI: Decodable {
    
    let results: [LocationResult]
    
}

struct LocationResult: Decodable {
    
    var id: Int
    var name: String
    var type: String
    var dimension: String
    var residents: [String]
    
}
