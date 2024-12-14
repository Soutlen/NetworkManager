//
//  Episod.swift
//  NetworkManager
//
//  Created by Евгений Глоба on 12/10/24.
//

import Foundation

struct Episode: Decodable {
    let results: [EpisodeResult]
}

struct EpisodeResult: Decodable {
    
    var id: Int
    var name: String
    //var air_date: String
    var episode: String
}
