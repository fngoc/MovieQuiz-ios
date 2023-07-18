//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 16.07.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
    func updateGameStatisticService(correct: Int, amount: Int)
}
