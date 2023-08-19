//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Виталий Хайдаров on 07.08.2023.
//

import XCTest
@testable import MovieQuiz // импортируем приложение для тестирования

final class MoviesLoaderTests: XCTestCase {
    
    func testSuccessLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) // говорим, что не хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        //When
        // так как функция загрузки фильмов — асинхронная, нужно ожидание
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            //Then
            switch result {
            case .success(_):
                // сравниваем данные с тем, что мы предполагали
                expectation.fulfill()
            case .failure(_):
                // мы не ожидаем, что пришла ошибка; если она появится, надо будет провалить тест
                XCTFail("Unexpected failure") // эта функция проваливает тест
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        //Given
        let stubNetworkClient = StubNetworkClient(emulateError: true) // говорим, что хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        //When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            //Then
            switch result {
            case .success(_):
                XCTFail("Unexpected success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5)
    }
}
