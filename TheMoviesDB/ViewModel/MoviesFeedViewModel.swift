//
//  MoviesFeedViewModel.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation
import Combine

class MoviesFeedViewModel {
    
    let action: PassthroughSubject<Action, Never> = .init()
    @Published var content: [MoviesFeedItemViewModel]
    
    private let model: Model
    private var bindings = Set<AnyCancellable>()
    
    init(_ model: Model) {
        
        self.content = []
        self.model = model
        
        bind()
    }
    
    private func bind() {
        
        action.sink { [unowned self] action in
            
            switch action {
            case _ as MoviesFeedViewModelAction.DownloadNext:
                model.action.send(ModelAction.DiscoverNextMovies())
                
            default:
                break
            }
            
        }.store(in: &bindings)
        
        model.movies
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] movies in
                
                let contentIds = content.map{ $0.id }
                
                for movie in movies {
                    
                    guard contentIds.contains(movie.id) == false else {
                        continue
                    }
                    
                    content.append(MoviesFeedItemViewModel(movie: movie, model: model))
                }
                
            }.store(in: &bindings)
    }
}

//MARK: - Action

enum MoviesFeedViewModelAction {

    struct DownloadNext: Action {}
}

