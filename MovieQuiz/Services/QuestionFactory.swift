//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 10.07.2023.
//

import Foundation

final class QuestionFactory {
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoadingProtocol
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
}

// MARK: - QuestionFactoryProtocol
extension QuestionFactory: QuestionFactoryProtocol {
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let text: String
            let correctAnswer: Bool
            let rating = Double(movie.rating) ?? 0
            
            let ratingQuestion = Double(arc4random_uniform(10))
            let moreOrLessFlag = Bool.random()
            
            if moreOrLessFlag {
                text = "Рейтинг фильма больше \(String(format: "%.0f", ratingQuestion))?"
                correctAnswer = rating > ratingQuestion
            } else {
                text = "Рейтинг фильма меньше \(String(format: "%.0f", ratingQuestion))?"
                correctAnswer = rating < ratingQuestion
            }
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
