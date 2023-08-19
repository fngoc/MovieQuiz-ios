//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 19.08.2023.
//

import Foundation

protocol MoviesLoadingProtocol {
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
