//
//  NetworkManager.swift
//  SimpleMovies
//
//  Created by Abderrahman Ajid on 27/8/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
}

actor NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3"
    
    private init() {}
    
    func fetchTrendingMovies() async throws -> [Movie] {
        let endpoint = "\(baseURL)/discover/movie?api_key=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(0)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            return movieResponse.results
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetail {
        let endpoint = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(0)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieDetail.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
