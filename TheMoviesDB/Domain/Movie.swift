//
//  File.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 02.12.2021.
//

import Foundation

struct Movie: Decodable, Identifiable, Hashable {
    
    let id: Int
    let title: String
    let overview: String
    let release: Date
    let isAdult: Bool
    let popularity: Double
    let voteAverage: Double
    let voteCount: Double
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case title
        case overview
        case release = "release_date"
        case isAdult = "adult"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case poster = "poster_path"
    }
}
