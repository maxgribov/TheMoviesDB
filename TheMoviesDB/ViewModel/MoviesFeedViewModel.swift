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
        
        model.movies
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] movies in
                
                let contentIds = content.map{ $0.id }
                var updated = content
                for movie in movies {
                    
                    guard contentIds.contains(movie.id) == false else {
                        continue
                    }
                    
                    updated.append(MoviesFeedItemViewModel(movie: movie, model: model))
                }
                content = updated
                
            }.store(in: &bindings)
        
        action.sink { [unowned self] action in
            
            switch action {
            case _ as MoviesFeedViewModelAction.DownloadNext:
                model.action.send(ModelAction.DiscoverNextMovies())
                
            default:
                break
            }
            
        }.store(in: &bindings)
    }
}

//MARK: - Action

enum MoviesFeedViewModelAction {

    struct DownloadNext: Action {}
}

