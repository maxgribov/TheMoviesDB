//
//  MoviesDetailHostingViewController.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 18.02.2022.
//

import Foundation
import SwiftUI

class MoviesDetailHostingViewController: UIHostingController<MoviesDetailView> {
    
    private let viewModel: MoviesDetailViewModel
    
    init(with viewModel: MoviesDetailViewModel) {
        
        self.viewModel = viewModel
        super.init(rootView: MoviesDetailView(viewModel: viewModel))
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
