//
//  MovieCellController.swift
//  Movies List
//
//  Created by Asad Ullah on 6/26/21.
//

import Foundation
import GenericCellControllers
import SDWebImage

let imageBaseUrl: String = "http://image.tmdb.org/t/p/w185"
class MovieCellController:GenericCellController<MovieCell> {
    private let movie: Movie
    private let coordinator: MovieCoordinator
    
    init(movie: Movie, coordinator: MovieCoordinator) {
        self.movie = movie
        self.coordinator = coordinator
    }
    
    override func configureCell(_ cell: MovieCell) {
    
        if let title = movie.movieTitle {
            cell.lblTitle.text = title
        }

        if let imageUrl = movie.poster_path {
            let fullPath = imageBaseUrl + imageUrl
            let url = URL(string: fullPath)
            guard let movieImageUrl = url  else {
                return
            }
            cell.movie_imageView.sd_setImage(with: movieImageUrl, completed:nil)
        }
        
    }
    
    override func didSelectCell() {
        coordinator.movieSelected(movie)
    }
}
