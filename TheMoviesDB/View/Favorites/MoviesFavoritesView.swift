//
//  MoviesFavoritesView.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 18.02.2022.
//

import SwiftUI

struct MoviesFavoritesView: View {
    
    @ObservedObject var viewModel: MoviesFavoritesViewModel
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                LazyVStack(spacing: 0) {
                    
                    ForEach(viewModel.content) { itemViewModel in
                        
                        ItemView(viewModel: itemViewModel)
                            .frame(height: 188)
                    }
                }
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension MoviesFavoritesView {
    
    struct ItemView: View {
        
        @ObservedObject var viewModel: MoviesFavoritesItemViewModel
        
        var body: some View {
            
            VStack(spacing: 0) {
                
                HStack(spacing: 12) {
                    
                    viewModel.posterImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    VStack(alignment:.leading, spacing: 6) {
                        
                        Text(viewModel.titleText)
                            .font(.system(size: 17, weight: .semibold))
                            .accessibilityIdentifier("Favorites Movie Title")
                        
                        Text(viewModel.overviewText)
                            .font(.system(size: 15, weight: .regular))
                        
                        Spacer()
                        
                    }.padding(.vertical, 6)
                    
                    Spacer()
                }
                
                Divider()
            }
        }
    }
}

struct MoviesFavoritesView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MoviesFavoritesView(viewModel: .sample)
    }
}
