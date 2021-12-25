//
//  RemoteImageAgentMock.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 25.12.2021.
//

import Foundation

class RemoteImageAgentMock: RemoteImageAgentProtocol {
    
    var baseURL: String = ""
    
    func loadImage(for movie: Movie, completion: @escaping (RemoteImageAgentResponse) -> Void) {
        
        completion(.failed(.emptyData))
    }

}
