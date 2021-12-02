//
//  RemoteImageAgent.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation
import UIKit

class RemoteImageAgent: RemoteImageAgentProtocol {
    
    let baseURL: String
    
    private let session = URLSession.cached
    
    init(baseURL: String) {
        
        self.baseURL = baseURL
    }
    
    func loadImage(for movie: Movie, completion: @escaping (RemoteImageAgentResponse) -> Void) {
        
        guard let imageURL = URL(string: baseURL + movie.poster) else {
            
            completion(.failed(.unableCreateImageURL))
            return
        }
        
        var request = URLRequest(url: imageURL)
        request.cachePolicy = .returnCacheDataElseLoad
        
        session.dataTask(with: request) { data, _, error in
            
            if let error = error {
                
                completion(.failed(.sessionError(error)))
                return
            }
            
            guard let data = data else {
                
                completion(.failed(.emptyData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                
                completion(.failed(.corruptedData))
                return
            }
            
            completion(.succeed(image))
        }
    }
}
