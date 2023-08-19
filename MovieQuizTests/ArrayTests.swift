//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Виталий Хайдаров on 07.08.2023.
//

import XCTest
@testable import MovieQuiz // импортируем приложение для тестирования

final class ArrayTests: XCTestCase {
    
    func testGiveValueInRange() throws {
        //Given
        let array = [1,2,3,4,5,6]
        let index = 2
        
        //When
        let result = array[safe: index]
        
        //Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 3)
    }
    
    func testGetValueOutOfRange() throws {
        //Given
        let array = [1,2,3,4,5,6]
        let index = 9
        
        //When
        let result = array[safe: index]
        
        //Then
        XCTAssertNil(result)
    }
}
