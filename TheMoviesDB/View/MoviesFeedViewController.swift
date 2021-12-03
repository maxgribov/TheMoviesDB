//
//  MoviesFeedViewController.swift
//  TheMoviesDB
//
//  Created by Max Gribov on 03.12.2021.
//

import UIKit
import Combine

class MoviesFeedViewController: UITableViewController {
    
    var viewModel: MoviesFeedViewModel?
    
    private var bindings = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        viewModel = MoviesFeedViewModel(appDelegate.model)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
 
    private func bind() {
        
        viewModel?.$content
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] _ in
                
                tableView.reloadData()
                
            }).store(in: &bindings)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel?.content.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Movie", for: indexPath)
        if let movieCell = cell as? MoviesFeedItemCell, let cellViewModel = viewModel?.content[indexPath.row] {
            
            movieCell.configure(with: cellViewModel)
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let totalItems = viewModel?.content.count else {
            return
        }
        
        if indexPath.row == totalItems - 1 {
            
            viewModel?.action.send(MoviesFeedViewModelAction.DownloadNext())
        }
    }
}
