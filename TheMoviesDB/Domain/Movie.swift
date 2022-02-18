//
//  File.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 02.12.2021.
//

import Foundation

typealias MovieId = Int

extension MovieId: Cachable {}

struct Movie: Cachable, Identifiable, Hashable {
    
    let id: MovieId
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

/*
 {
     "adult": false,
     "backdrop_path": "/70nxSw3mFBsGmtkvcs91PbjerwD.jpg",
     "genre_ids": [
         878,
         28,
         12
     ],
     "id": 580489,
     "original_language": "en",
     "original_title": "Venom: Let There Be Carnage",
     "overview": "After finding a host body in investigative reporter Eddie Brock, the alien symbiote must face a new enemy, Carnage, the alter ego of serial killer Cletus Kasady.",
     "popularity": 13071.277,
     "poster_path": "/rjkmN1dniUHVYAtwuV3Tji7FsDO.jpg",
     "release_date": "2021-09-30",
     "title": "Venom: Let There Be Carnage",
     "video": false,
     "vote_average": 7.2,
     "vote_count": 3726
 }
 */
