//
//  Model.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation
import Combine
import os

class Model {
    
    let action: PassthroughSubject<Action, Never> = .init()
    var movies: CurrentValueSubject<[Movie], Never> = .init([])
    
    private let serverAgent: ServerAgentProtocol
    private var bindings = Set<AnyCancellable>()
    private var currentPage = 0
    private let logger = Logger(subsystem: "com.maxgribov.TheMovieDB", category: "Model")
    
    init(serverAgent: ServerAgentProtocol) {
        
        self.serverAgent = serverAgent
        
        bind()
        
        // download initial movies page
        action.send(ModelAction.DiscoverNextMovies())
    }
    
    private func bind() {
        
        action.sink { [unowned self] action in
            
            switch action {
            case _ as ModelAction.DiscoverNextMovies:
                let discoveringPage = currentPage + 1
                let command = ServerCommands.Discover(page: discoveringPage)
                let completion:((ServerResponse<ServerCommands.Discover.Response, ServerAgentError>) -> Void ) = {[unowned self] result in
                    
                    switch result {
                    case .succeed(let response):
                        movies.value.append(contentsOf: response.results)
                        currentPage = discoveringPage
                        
                    case .failed(let error):
                        logger.error("\(error.localizedDescription)")
                    }
                }
                
                serverAgent.execute(command: command, completion: completion)
                
            default:
                break
            }
            
        }.store(in: &bindings)
    }
}

enum ModelAction {
    
    struct DiscoverNextMovies: Action {}
}
