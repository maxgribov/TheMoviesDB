//
//  ServerCommands.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation

enum ServerCommands {

    struct Discover: ServerCommand {
        
        let page: Int
        
        let endpoint = "/discover/movie"
        let method: ServerCommandMethod = .get
        let parameters: [String]
        
        init(page: Int) {
            
            self.page = page
            self.parameters = ["&page=\(page)"]
        }
        
        struct Response: Decodable {
            
            let page: Int
            let results: [Movie]
        }
    }
}
