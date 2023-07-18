//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 12.07.2023.
//

import Foundation

struct AlertModel {
    let text: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
