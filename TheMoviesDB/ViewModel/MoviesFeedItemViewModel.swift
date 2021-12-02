//
//  MoviesFeedItemViewModel.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import Foundation
import Combine
import UIKit

class MoviesFeedItemViewModel {
    
    let id: Movie.ID
    let titleText: String
    @Published var posterImage: UIImage?
    
    private let model: Model
    private var bindings = Set<AnyCancellable>()
    
    init(movie: Movie, model: Model) {
        
        self.id = movie.id
        self.titleText = movie.title
        self.posterImage = nil
        self.model = model
        
        bind()
        
        // download image
        model.action.send(ModelAction.MoviePoster.Requested(movie: movie))
    }
    
    private func bind() {
        
        model.action
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] action in
                
                switch action {
                case let payload as ModelAction.MoviePoster.Complete:
                    guard payload.movieId == id else {
                        return
                    }
                    posterImage = payload.image
                    
                default:
                    break
                }
                
            }.store(in: &bindings)
    }
}
