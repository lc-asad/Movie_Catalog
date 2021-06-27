//
//  MovieViewController.swift
//  Movies List
//
//  Created by Asad Ullah on 6/26/21.
//

import UIKit
import Combine

let banerBaseUrl: String = "http://image.tmdb.org/t/p/w500"
class MovieDetailViewController: UIViewController {
   
    //MARK: - IBOutlets
    @IBOutlet weak var banerImageView: UIImageView!
    @IBOutlet weak var lblTitile: UILabel!
    @IBOutlet weak var lblGeners: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOverView: UILabel!
    
    //MARK: - Variables
    var movie: Movie?
    
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Detail"
        loadData()
    }
    
    //MARK: - Show movie data
    private func loadData() {
        guard let movie = movie else {
            return
        }
        lblTitile.text = movie.movieTitle
        lblDate.text = movie.release_date
        lblOverView.text = movie.overview
        
        if let imageUrl = movie.poster_path {
            let fullPath = banerBaseUrl + imageUrl
            let url = URL(string: fullPath)
            guard let movieImageUrl = url  else {
                return
            }
            banerImageView.sd_setImage(with: movieImageUrl, completed:nil)
        }
    }
    
    //MARK: - UIBution action
    @IBAction func btnShowTrailer(_ sender: UIButton) {
        
    }
}
