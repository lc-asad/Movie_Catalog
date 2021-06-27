//  ApiService.swift
//  Movies List
//
//  Created by Asad Ullah on 6/27/21.

import Foundation
import Combine

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

protocol MovieServiceProtocol {
    func get(page: Int) -> AnyPublisher<MovieResponse, Error>
}

final class MovieService: MovieServiceProtocol {
    
    func get(page: Int) -> AnyPublisher<MovieResponse, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<MovieResponse, Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest(page: page) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    
                    let cartResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                    promise(.success(cartResponse))
                } catch  let error {
                    print("Error in reponse:", error)
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getUrlRequest(page: Int) -> URLRequest? {
        
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=27f33a65f6c0cb59be95dacf2ab0b5b9&page=\(page)"
        let url = URL(string: urlString)!
        print("Final URL: ",url)
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30.0
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}
