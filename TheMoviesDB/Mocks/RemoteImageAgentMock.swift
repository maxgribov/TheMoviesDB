//
//  RemoteImageAgentMock.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 25.12.2021.
//

import Foundation
import UIKit

class RemoteImageAgentMock: RemoteImageAgentProtocol {
    
    var baseURL: String = ""
    
    func loadImage(for movie: Movie, completion: @escaping (RemoteImageAgentResponse) -> Void) {
        
        guard let image = UIImage(named: "Sample Poster Image") else {
            completion(.failed(.emptyData))
            return
        }
        
        completion(.succeed(image))
    }

}
