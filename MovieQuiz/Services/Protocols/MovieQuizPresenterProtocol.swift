//
//  MovieQuizPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 19.08.2023.
//

import UIKit

protocol MovieQuizPresenterProtocol {
    
    func noButtonAction(_ sender: UIButton)
    
    func yesButtonAction(_ sender: UIButton)
    
    func reloadGame()
    
    func restartGame()
    
    func makeMessage() -> String
    
    func updateStatisticService()
    
    func convert(model: QuizQuestion) -> QuizStepViewModel
}
