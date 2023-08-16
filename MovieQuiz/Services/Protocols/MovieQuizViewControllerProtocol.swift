//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 16.08.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func setUnavailableButtons()
    func setAvailableButtons()
    
    func showResult()
    
    func removeStrokeAroundImage()
}
