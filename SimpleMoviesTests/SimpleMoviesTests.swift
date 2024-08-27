//
//  SimpleMoviesTests.swift
//  SimpleMoviesTests
//
//  Created by Abderrahman Ajid on 27/8/2024.
//

import XCTest
@testable import SimpleMovies

final class SimpleMoviesTests: XCTestCase {
    
    func testMovieDecoding() {
        let json = """
            {
                "id": 1,
                "title": "Test Movie",
                "poster_path": "/test.jpg",
                "overview": "This is a test movie."
            }
            """
        
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let movie = try decoder.decode(Movie.self, from: jsonData)
            XCTAssertEqual(movie.id, 1)
            XCTAssertEqual(movie.title, "Test Movie")
            XCTAssertEqual(movie.posterPath, "/test.jpg")
            XCTAssertEqual(movie.overview, "This is a test movie.")
        } catch {
            XCTFail("Failed to decode Movie: \(error)")
        }
    }
    
    func testMovieDetailDecoding() {
        let json = """
            {
                "id": 1,
                "title": "Test Movie",
                "poster_path": "/test.jpg",
                "overview": "This is a test movie.",
                "release_date": "2023-01-01",
                "vote_average": 7.5,
                "genres": [
                    {
                        "id": 28,
                        "name": "Action"
                    },
                    {
                        "id": 12,
                        "name": "Adventure"
                    }
                ]
            }
            """
        
        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let movieDetail = try decoder.decode(MovieDetail.self, from: jsonData)
            XCTAssertEqual(movieDetail.id, 1)
            XCTAssertEqual(movieDetail.title, "Test Movie")
            XCTAssertEqual(movieDetail.posterPath, "/test.jpg")
            XCTAssertEqual(movieDetail.overview, "This is a test movie.")
            XCTAssertEqual(movieDetail.releaseDate, "2023-01-01")
            XCTAssertEqual(movieDetail.voteAverage, 7.5)
            XCTAssertEqual(movieDetail.genres.count, 2)
            XCTAssertEqual(movieDetail.genres[0].name, "Action")
            XCTAssertEqual(movieDetail.genres[1].name, "Adventure")
        } catch {
            XCTFail("Failed to decode MovieDetail: \(error)")
        }
    }
    
    func testNetworkManager() async throws {
        do {
            let movies = try await NetworkManager.shared.fetchTrendingMovies()
            XCTAssertFalse(movies.isEmpty, "Trending movies should not be empty")
        } catch {
            XCTFail("Failed to fetch trending movies: \(error)")
        }
    }
}
