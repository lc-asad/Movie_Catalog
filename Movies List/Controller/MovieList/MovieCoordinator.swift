//
//  MovieCoordinator.swift
//  Movies List
//
//  Created by Asad Ullah on 6/27/21.
//

import Foundation
import UIKit

class MovieCoordinator {

    private weak var viewController: MovieListViewController?

    init(viewController: MovieListViewController?) {
        self.viewController = viewController
    }

    func movieSelected(_ movie: Movie) {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
        detailViewController.movie = movie
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
