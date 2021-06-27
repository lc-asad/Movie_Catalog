//
//  MovieCellControllerFactory.swift
//  Movies List
//
//  Created by Asad Ullah on 6/26/21.
//

import Foundation
import GenericCellControllers


class MovieCellControllerFactory {
    
    func registerCells(on tableView: UITableView) {
        
        MovieCellController.registerCell(on: tableView)
    }
    
    func cellControllers(from elements: [MovieElement], coordinator: MovieCoordinator) -> [TableCellController] {
        
        return elements.map { (element) in
            switch element {
            case .movie(let movie):
                return MovieCellController(movie: movie, coordinator: coordinator)
            }
        }
    }
}
