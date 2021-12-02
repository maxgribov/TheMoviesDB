//
//  RemoteImageAgentProtocol.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import UIKit

protocol RemoteImageAgentProtocol {
    
    var baseURL: String { get }

    func loadImage(for movie: Movie, completion: @escaping (RemoteImageAgentResponse) -> Void)
}

enum RemoteImageAgentResponse {
    
    case succeed(UIImage)
    case failed(RemoteImageAgentError)
}

enum RemoteImageAgentError: Error {
    
    case unableCreateImageURL
    case sessionError(Error)
    case emptyData
    case corruptedData
}

