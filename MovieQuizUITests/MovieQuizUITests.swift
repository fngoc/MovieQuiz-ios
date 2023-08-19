//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Виталий Хайдаров on 09.08.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    // Запросы выполняются с корректным API Key
    func testYesButton() throws {
        // Given
        sleep(3)
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation // делаем скриншот и возвращаем ее Data
        let yesButton = app.buttons["Yes"] // находим кнопку ответа
        
        // When
        yesButton.tap()
        sleep(3)
        
        // Then
        let secondPoster = app.images["Poster"] // новый постре
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(firstPoster.exists)
        XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем что послеры разные
    }
    
    // Запросы выполняются с корректным API Key
    func testNoButton() throws {
        // Given
        sleep(3)
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation // делаем скриншот и возвращаем ее Data
        let noButton = app.buttons["No"] // находим кнопку ответа
        
        // When
        noButton.tap()
        sleep(3)
        
        // Then
        let secondPoster = app.images["Poster"] // новый постре
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(firstPoster.exists)
        XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем что послеры разные
    }

    func testIndexLabel() throws {
        // Given
        let indexLabel = app.staticTexts["Index"]
        let yesButton = app.buttons["Yes"]
        
        // When
        yesButton.tap()
        sleep(3)
        
        // Then
        XCTAssertEqual(indexLabel.label, "2/10")
    }

    func testAlert() throws {
        // Given
        let yesButton = app.buttons["Yes"]
        
        // When
        iterateByQuestions(button: yesButton, count: 9)
        
        // Then
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testNextRound() throws {
        // Given
        let yesButton = app.buttons["Yes"]
        
        // When
        iterateByQuestions(button: yesButton, count: 9)
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        sleep(3)
        
        // Then
        let label = app.staticTexts["Index"]
        XCTAssertEqual(label.label, "1/10")
    }
    
    private func iterateByQuestions(button: XCUIElement, count: Int) {
        for _ in 0...count {
            button.tap()
            sleep(1)
        }
    }
}
