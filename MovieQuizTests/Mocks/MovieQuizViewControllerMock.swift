//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Виталий Хайдаров on 19.08.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    
    func setUnavailableButtons() { }
    
    func setAvailableButtons() { }
    
    func showResult() { }
    
    func removeStrokeAroundImage() { }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) { }
    
    func highlightImageBorder(isCorrectAnswer: Bool) { }
    
    func showLoadingIndicator() { }
    
    func hideLoadingIndicator() { }
    
    func showNetworkError(message: String) { }
}
