//
//  MovieDetailViewController.swift
//  SimpleMovies
//
//  Created by Abderrahman Ajid on 27/8/2024.
//

import UIKit

@MainActor
class MovieDetailViewController: UIViewController {
    private let movieId: Int
    private var movieDetail: MovieDetail?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let ratingLabel = UILabel()
    private let genresLabel = UILabel()
    
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task {
            await fetchMovieDetails()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [posterImageView, titleLabel, overviewLabel, releaseDateLabel, ratingLabel, genresLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 200),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            releaseDateLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genresLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genresLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        
        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        
        [releaseDateLabel, ratingLabel, genresLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.numberOfLines = 0
        }
    }
    
    private func fetchMovieDetails() async {
        do {
            movieDetail = try await NetworkManager.shared.fetchMovieDetails(movieId: movieId)
            updateUI()
        } catch {
            handleError(error)
        }
    }
    
    private func updateUI() {
        guard let movieDetail = movieDetail else { return }
        
        title = movieDetail.title
        titleLabel.text = movieDetail.title
        overviewLabel.text = movieDetail.overview
        releaseDateLabel.text = "Release Date: \(movieDetail.releaseDate)"
        ratingLabel.text = "Rating: \(String(format: "%.1f", movieDetail.voteAverage))/10"
        genresLabel.text = "Genres: \(movieDetail.genres.map { $0.name }.joined(separator: ", "))"
        
        if let posterPath = movieDetail.posterPath {
            let imageURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
            Task {
                await loadImage(from: imageURL)
            }
        }
    }
    
    private func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                posterImageView.image = image
            }
        } catch {
            print("Error loading image: \(error.localizedDescription)")
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
        default:
            errorMessage = "An unexpected error occurred. Please try again."
        }
        
        AlertManager.showAlert(on: self, title: "Error", message: errorMessage)
    }
}
