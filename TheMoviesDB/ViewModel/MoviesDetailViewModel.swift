//
//  MoviesDetailViewModel.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 18.02.2022.
//

import Foundation
import Combine
import SwiftUI

class MoviesDetailViewModel: ObservableObject {
    
    let id: Movie.ID
    let titleText: String
    let overviewText: String
    @Published var posterImage: Image
    @Published var isFavorite: Bool
    @Published var favoriteButton: FavoriteButtonViewModel
    
    private let model: Model
    private var bindings = Set<AnyCancellable>()
    
    internal init(id: Movie.ID, titleText: String, overviewText: String, posterImage: Image, isFavorite: Bool, favoriteButton: FavoriteButtonViewModel, model: Model = .mock) {
       
        self.id = id
        self.titleText = titleText
        self.overviewText = overviewText
        self.posterImage = posterImage
        self.isFavorite = isFavorite
        self.favoriteButton = favoriteButton
        self.model = model
    }
    
    init(movie: Movie, model: Model) {
        
        self.id = movie.id
        self.titleText = Self.prepareTitle(movie: movie)
        self.overviewText = movie.overview
        self.posterImage = Image("Poster Placeholder")
        self.isFavorite = model.isFavorite(movieId: movie.id)
        self.favoriteButton = .init(isFavorite: false, action: {})
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
        
        $isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] isFavorite in
                
                model.updateFavorite(movieId: id, isFavorite: isFavorite)
                self.favoriteButton = .init(isFavorite: isFavorite, action: {[weak self] in self?.isFavorite.toggle() })
                
            }.store(in: &bindings)
    }
}

extension MoviesDetailViewModel {
    
    struct FavoriteButtonViewModel {
        
        let icon: Image
        let action: () -> Void
        
        init(isFavorite: Bool, action: @escaping () -> Void) {
            
            self.icon = Image(systemName: isFavorite ? "star.fill" : "star")
            self.action = action
        }
    }
}

extension MoviesDetailViewModel {
    
    static let sample = MoviesDetailViewModel(id: 123, titleText: "Superman & Lois", overviewText: "After years of facing megalomaniacal supervillains, monsters wreaking havoc on Metropolis, and alien invaders intent on wiping out the human race, The Man of Steel aka Clark Kent and Lois Lane come face to face with one of their greatest challenges ever: dealing with all the stress, pressures and complexities that come with being working parents in today's society.", posterImage: Image("Sample Poster Image"), isFavorite: false, favoriteButton: .init(isFavorite: false, action: {}))
}
