//
//  MoviesFeedItemCell.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import UIKit
import Combine

class MoviesFeedItemCell: UITableViewCell {
    
    var viewModel: MoviesFeedItemViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    private var bindings = Set<AnyCancellable>()

    func configure(with viewModel: MoviesFeedItemViewModel) {
    
        titleLabel.text = viewModel.titleText
        overviewTextView.text = viewModel.overviewText
        //TODO: poster image placeholder
        self.viewModel = viewModel
        
        bind()
    }
    
    private func bind() {
        
        viewModel?.$posterImage
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                
                self?.posterImageView.image = image
                
            }).store(in: &bindings)
    }

    override func prepareForReuse() {
        
        bindings = Set<AnyCancellable>()
        viewModel = nil
        titleLabel.text = nil
        overviewTextView.text = nil
        posterImageView.image = nil
    }
}
