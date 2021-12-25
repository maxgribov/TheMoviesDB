//
//  AppDelegate.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 02.12.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var model: Model = {
        
        switch LaunchContext.environment {
        case .prod:
            return Model(serverAgent: ServerAgent(baseURL: "https://api.themoviedb.org/3", apiKey: "c1f618b7255f013ad044c579d688e1c2"), remoteImageAgent: RemoteImageAgent(baseURL: "http://image.tmdb.org/t/p/w780"), loacalAgent: LocalAgent(rootFolderName: "cache"))
            
        case .testUI:
            return Model(serverAgent: ServerAgentMock(), remoteImageAgent: RemoteImageAgentMock(), loacalAgent: LocalAgentMock())
        }
    }()
}

