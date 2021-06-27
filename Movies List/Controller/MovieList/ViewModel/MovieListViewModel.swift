//
//  MovieListViewModel.swift
//  Movies List
//
//  Created by Asad Ullah on 6/26/21.
//

import Foundation
import Combine

enum ListViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

class MovieListViewModel {
    
    @Published private(set) var movieResponse: MovieResponse?
    @Published private(set) var state: ListViewModelState = .loading
    
    private let movieService: MovieServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
        fetchMovies(page: 1)
    }
    
    func fetchMovies(page: Int) {
        state = .loading
        
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error): self?.state = .error(error)
            case .finished: self?.state = .finishedLoading
            }
        }
        
        let cartValueHandler: (MovieResponse) -> Void = { [weak self] moviesData in
            self?.movieResponse = moviesData
        }
        movieService
            .get(page: page)
            .sink(receiveCompletion: completionHandler, receiveValue: cartValueHandler)
            .store(in: &bindings)
    }
}
