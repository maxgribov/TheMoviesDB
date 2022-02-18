//
//  MoviesFavoritesViewModel.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 18.02.2022.
//

import Foundation
import Combine
import SwiftUI

class MoviesFavoritesViewModel: ObservableObject {
    
    let action: PassthroughSubject<Action, Never> = .init()
    let title = "Favorites"
    @Published var content: [MoviesFavoritesItemViewModel]
    
    private let model: Model
    private var bindings = Set<AnyCancellable>()
    
    init(content: [MoviesFavoritesItemViewModel], model: Model = .mock) {
        
        self.content = content
        self.model = model
    }
    
    init(_ model: Model) {
        
        self.content = []
        self.model = model
        
        bind()
    }
    
    func bind() {
        
        model.favorites
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] favorites in
                
                content = favorites.reversed().compactMap({ favoriteMovieId in
                    
                    guard let movie = model.movies.value.first(where: { $0.id == favoriteMovieId}) else {
                        return nil
                    }
                    
                    return MoviesFavoritesItemViewModel(movie: movie, model: model)
                })
               
            }.store(in: &bindings)
    }
}

extension MoviesFavoritesViewModel {
    
    static let sample = MoviesFavoritesViewModel(content: [.init(id: 123, titleText: "Superman & Lois", overviewText: "After years of facing megalomaniacal supervillains, monsters wreaking havoc on Metropolis, and alien invaders intent on wiping out the human race, The Man of Steel aka Clark Kent and Lois Lane come face to face with one of their greatest challenges ever: dealing with all the stress, pressures and complexities that come with being working parents in today's society.", posterImage: Image("Sample Poster Image")), .init(id: 234, titleText: "Superman & Lois", overviewText: "After years of facing megalomaniacal supervillains, monsters wreaking havoc on Metropolis, and alien invaders intent on wiping out the human race.", posterImage: Image("Sample Poster Image"))])
}
