//
//  MovieListViewController.swift
//  Movies List
//
//  Created by Asad Ullah on 6/26/21.
//

import UIKit
import Combine
import GenericCellControllers

class MovieListViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var tblMovieList: UITableView!
    
    //MARK: - Variables
    private var bindings = Set<AnyCancellable>()
    var movies = [Movie]()
    private var isLoading: Bool = false
    private var total_pages: Int = 0
    private var current_page: Int = 1
    private var data: [MovieElement] = [MovieElement]()
    private var cellControllers: [TableCellController] = []
    lazy var activityIndicationView = ActivityIndicatorView(style: .medium)
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    lazy var viewModel: MovieListViewModel = {
        let viewModel = MovieListViewModel()
        return viewModel
    }()
    
    //MARK: - Constants
    private let cellControllerFactory = MovieCellControllerFactory()
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Catalog"
        addLaoder()
        setUpTableView()
        setUpBindings()
    }
    
    //MARK: - setUpTableView
    private func setUpTableView() {
        
        if Constants.IS_IPAD{
            tblMovieList.rowHeight = 250
        }else {
            tblMovieList.rowHeight = 120
        }
        configureRefreshController()
        tblMovieList.tableFooterView = UIView.init(frame: .zero)
        cellControllerFactory.registerCells(on: tblMovieList)
        
    }
    
    //MARK: - add Laoder
    private func addLaoder() {
        view.addSubview(activityIndicationView)
        activityIndicationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicationView.heightAnchor.constraint(equalToConstant: 50),
            activityIndicationView.widthAnchor.constraint(equalToConstant: 50.0)
        ])
        view.bringSubviewToFront(activityIndicationView)
    }
    
    //MARK: - Add refresh Control
    private func configureRefreshController() {
        refreshControl.addTarget(self, action: #selector(self.refreshList(_:)), for: .valueChanged)
        tblMovieList.addSubview(refreshControl)
    }
    @objc  func refreshList(_ sender: AnyObject) {
        
        if data.count > 0 {
            data.removeAll()
        }
        
        current_page = 1
        viewModel.fetchMovies(page: current_page)
    }
    
    //MARK: - setUpBindings
    private func setUpBindings() {
        func bindViewModelToView() {
            viewModel.$movieResponse
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] moviesData  in
                    guard let moviesData = moviesData else{
                        return
                    }
                    self?.loadMovieList(movieResponse: moviesData)
                })
                .store(in: &bindings)
            let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    self?.startLoading()
                case .finishedLoading:
                    self?.finishLoading()
                case .error(let error):
                    self?.finishLoading()
                    self?.showError(error)
                }
            }
            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
        }
        bindViewModelToView()
    }
    
    //MARK: - load tableview
    private func loadMovieList(movieResponse: MovieResponse) {
        
        total_pages = movieResponse.total_pages
        if let movies = movieResponse.result {
            self.movies = movies
            
            for movie in movies {
                data.append(.movie(movie))
            }
            
            cellControllers = cellControllerFactory.cellControllers(from: data, coordinator: MovieCoordinator(viewController: self))
            tblMovieList.reloadData()
        }
    }
    
    //MARK: - Show error alert
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Start / Stop loader activity
    func startLoading() {
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func finishLoading() {
        
        activityIndicationView.stopAnimating()
        refreshControl.endRefreshing()
        isLoading = false
    }
}


extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return cellControllers[indexPath.row].cellFromReusableCellHolder(tableView, forIndexPath: indexPath)
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellControllers[indexPath.row].didSelectCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = cellControllers.count - 1
        if !isLoading && indexPath.row == lastElement && current_page < total_pages {
            isLoading = true
            current_page += 1
            viewModel.fetchMovies(page: current_page)
        }
    }
}
