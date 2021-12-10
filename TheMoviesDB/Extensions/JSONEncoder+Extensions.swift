//
//  JSONEncoder+Extensions.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 11.12.2021.
//

import Foundation

extension JSONEncoder {
    
    static let movieDB: JSONEncoder = {
       
        let encoder = JSONEncoder()
        let formatter = DateFormatter.movieDB
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        return encoder
    }()
}
