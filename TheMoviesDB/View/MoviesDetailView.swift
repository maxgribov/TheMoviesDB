//
//  MoviesDetailView.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 18.02.2022.
//

import SwiftUI

struct MoviesDetailView: View {
    
    @ObservedObject var viewModel: MoviesDetailViewModel
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                viewModel.posterImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(viewModel.overviewText)
                    .font(.body)
                    .padding()
            }
        }
        .navigationTitle(viewModel.titleText)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.favoriteButton.action) {
                    viewModel.favoriteButton.icon
                }
            }
        }
    }
}

struct MoviesDetailViewModel_Previews: PreviewProvider {
   
    static var previews: some View {
        
        NavigationView {
            
            MoviesDetailView(viewModel: .sample)
        }
    }
}
