//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Виталий Хайдаров on 16.08.2023.
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

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        // Given
        let vieController = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(controller: vieController)
        
        // When
        let message = presenter.makeMessage()
        let firstStr = message.split(separator: "\n")[0]
        
        // Then
        XCTAssertEqual(firstStr, "Ваш результат: 0/10")
    }
}
