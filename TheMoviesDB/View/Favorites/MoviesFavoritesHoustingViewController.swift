//
//  MoviesFavoritesHoustingViewController.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 18.02.2022.
//

import Foundation
import UIKit
import SwiftUI

class MoviesFavoritesHoustingViewController: UIHostingController<MoviesFavoritesView> {
    
    var viewModel: MoviesFavoritesViewModel
    
    init(with viewModel: MoviesFavoritesViewModel) {
        
        self.viewModel = viewModel
        super.init(rootView: MoviesFavoritesView(viewModel: viewModel))
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let viewModel = MoviesFavoritesViewModel(appDelegate.model)
        self.viewModel = viewModel
        super.init(rootView: MoviesFavoritesView(viewModel: viewModel))
        
        tabBarItem = .init(title: "Favorites", image: UIImage(systemName: "star"), tag: 2)
    }
}
