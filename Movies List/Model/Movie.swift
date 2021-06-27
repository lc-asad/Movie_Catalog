//
//  Movie.swift
//  Movies List
//
//  Created by Asad Ullah on 6/26/21.
//

import Foundation

enum MovieElement {
    case movie(Movie)
}

struct MovieResponse: Codable {
    let page: Int
    let total_pages: Int
    let total_results: Int
    let result: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case total_pages
        case total_results
        case result = "results"
    }
}

struct Movie: Equatable, Hashable, Codable {
    
    let movieId: Int
    let movieTitle: String?
    let overview: String
    let backdrop_path: String?
    let poster_path: String?
    let video: Bool
    let release_date: String?
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case movieTitle = "title"
        case overview
        case backdrop_path
        case poster_path
        case video
        case release_date
        
    }
}
