//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Виталий Хайдаров on 16.08.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        // Given
        let vieController = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(controller: vieController)
        
        // When
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        // Then
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
    
    func testEmptyStatistic() throws {
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
