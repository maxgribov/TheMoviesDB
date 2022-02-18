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
    let overviewText: String
    @Published var posterImage: UIImage?
    
    private let model: Model
    private var bindings = Set<AnyCancellable>()
    
    init(movie: Movie, model: Model) {
        
        self.id = movie.id
        self.titleText = Self.prepareTitle(movie: movie)
        self.overviewText = movie.overview
        self.posterImage = UIImage(named: "Poster Placeholder")
        self.model = model

        bind()
        
        // download image
        model.action.send(ModelAction.MoviePoster.Requested(movie: movie))
    }
   
    static func prepareTitle(movie: Movie) -> String {
        movie.title.capitalized
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
