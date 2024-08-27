//
//  MoviesListViewController.swift
//  SimpleMovies
//
//  Created by Abderrahman Ajid on 27/8/2024.
//

import UIKit

@MainActor
class MoviesListViewController: UIViewController {
    private let tableView = UITableView()
    private var movies: [Movie] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task {
            await fetchMovies()
        }
    }
    
    private func setupUI() {
        title = "Trending Movies"
        view.backgroundColor = .systemBackground
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        view.addSubview(tableView)
        
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshTapped))
    }
    
    private func fetchMovies() async {
        activityIndicator.startAnimating()
        
        do {
            movies = try await NetworkManager.shared.fetchTrendingMovies()
            tableView.reloadData()
        } catch {
            handleError(error)
        }
        
        activityIndicator.stopAnimating()
    }
    
    @objc private func refreshTapped() {
        Task {
            await fetchMovies()
        }
    }
    
    private func handleError(_ error: Error) {
        let errorMessage: String
        switch error {
        case NetworkError.invalidURL:
            errorMessage = "Invalid URL. Please try again later."
        case NetworkError.noData:
            errorMessage = "No data received. Please check your internet connection and try again."
        case NetworkError.decodingError:
            errorMessage = "Error processing the data. Please try again later."
        case NetworkError.serverError(let statusCode):
            errorMessage = "Server error: \(statusCode). Please try again later."
        default:
            errorMessage = "An unexpected error occurred. Please try again."
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let detailVC = MovieDetailViewController(movieId: movie.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
