//
//  JSONDecoder+Extensions.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation

extension JSONDecoder {
    
    static let movieDB: JSONDecoder = {
       
        let decoder = JSONDecoder()
        let formatter = DateFormatter.movieDB
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }()
}
