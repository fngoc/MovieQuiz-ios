//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 12.07.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
