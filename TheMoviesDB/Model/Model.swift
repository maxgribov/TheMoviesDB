//
//  Model.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation
import Combine
import os
import UIKit

class Model {
    
    let action: PassthroughSubject<Action, Never> = .init()
    private (set) var movies: CurrentValueSubject<[Movie], Never> = .init([])
    
    private let serverAgent: ServerAgentProtocol
    private let remoteImageAgent: RemoteImageAgentProtocol
    private let loacalAgent: LocalAgentProtocol
    
    private var bindings = Set<AnyCancellable>()
    private var currentPage = 0
    private let logger = Logger(subsystem: "com.maxgribov.TheMovieDB", category: "Model")
    private let queue = DispatchQueue(label: "pro.maxgribov.TheMoviesDB.model", qos: .userInitiated, attributes: .concurrent)
    
    init(serverAgent: ServerAgentProtocol, remoteImageAgent: RemoteImageAgentProtocol, loacalAgent: LocalAgentProtocol) {
        
        self.serverAgent = serverAgent
        self.remoteImageAgent = remoteImageAgent
        self.loacalAgent = loacalAgent
        
        bind()
        
        loadCachedData {[unowned self] result in
            
            if result == false {
                
                // download initial movies page
                action.send(ModelAction.DiscoverNextMovies())
            }
        }
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
                        queue.async {
                            
                            do {
                                
                                try loacalAgent.store(movies.value, serial: discoveringPage)
                                
                            } catch  {
                                
                                logger.error("store to cache movies data error: \(error.localizedDescription)")
                            }
                        }

                        
                    case .failed(let error):
                        logger.error("fetching next movies page error: \(error.localizedDescription)")
                    }
                }
                
                serverAgent.execute(command: command, completion: completion)
                
            case let payload as ModelAction.MoviePoster.Requested:
                remoteImageAgent.loadImage(for: payload.movie) { [unowned self] response in
                    
                    switch response {
                    case .succeed(let image):
                        self.action.send(ModelAction.MoviePoster.Complete(movieId: payload.movie.id, image: image))
                    
                    case .failed(let error):
                        self.action.send(ModelAction.MoviePoster.Failed(error: error))
                    }
                }
                
            default:
                break
            }
            
        }.store(in: &bindings)
    }
    
    private func loadCachedData(completion: @escaping (Bool) -> Void) {
        
        queue.async { [unowned self] in
        
            if let cachedMovies = loacalAgent.load(type: Movie.self) {
                
                movies.value = cachedMovies.data
                currentPage = cachedMovies.serial ?? 0
                completion(true)
                
            } else {
                
                completion(false)
            }
        }
    }
}

//MARK: - Action

enum ModelAction {
    
    struct DiscoverNextMovies: Action {}
    
    enum MoviePoster {
        
        struct Requested: Action {
            
            let movie: Movie
        }
        
        struct Complete: Action  {
            
            let movieId: Movie.ID
            let image: UIImage
        }
        
        struct Failed: Action {
            
//            let movieId: Movie.ID
            let error: Error
        }
    }
}
