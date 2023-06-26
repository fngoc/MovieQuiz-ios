//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 26.06.2023.
//

import Foundation

struct QuizQuestion {
    // строка с названием фильма,
    // совпадает с названием картинки афиши фильма в Assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // булево значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
