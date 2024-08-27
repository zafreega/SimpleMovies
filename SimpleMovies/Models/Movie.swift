//
//  Movie.swift
//  SimpleMovies
//
//  Created by Abderrahman Ajid on 27/8/2024.
//

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
}

// MovieDetail.swift

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
