//
//  Character.swift
//  NetworkManager
//
//  Created by Евгений Глоба on 12/1/24.
//

import Foundation

struct Character: Decodable {
    
    let results: [CharacterResult]
    }
    
    struct CharacterResult: Decodable {
        
        var id: Int
        var name: String
        var status: String
        var species: String
        var gender: String
        var origin: Origin
        var location: Location
        var image: String
        }
    
    struct Origin: Decodable {
        let name: String
    }
    
    struct Location: Decodable {
        let name: String
    }
