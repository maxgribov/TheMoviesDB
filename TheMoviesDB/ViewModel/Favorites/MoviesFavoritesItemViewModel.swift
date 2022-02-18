//
//  MoviesFavoritesItemViewModel.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 18.02.2022.
//

import Foundation
import Combine
import SwiftUI

class MoviesFavoritesItemViewModel: Identifiable, ObservableObject {

    let id: Movie.ID
    let titleText: String
    let overviewText: String
    @Published var posterImage: Image
    
    private let model: Model
    private var bindings = Set<AnyCancellable>()
    
    internal init(id: Movie.ID, titleText: String, overviewText: String, posterImage: Image, model: Model = .mock) {
        
        self.id = id
        self.titleText = titleText
        self.overviewText = overviewText
        self.posterImage = posterImage
        self.model = model
    }
    
    init(movie: Movie, model: Model) {
        
        self.id = movie.id
        self.titleText = Self.prepareTitle(movie: movie)
        self.overviewText = movie.overview
        self.posterImage = Image("Poster Placeholder")
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
                    posterImage = Image(uiImage: payload.image)
                    
                default:
                    break
                }
                
            }.store(in: &bindings)
    }
}
