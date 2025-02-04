//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 16.07.2023.
//

import Foundation

final class StatisticServiceImplementation {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAnswers
    }
    
    private let userDefaults = UserDefaults.standard
    
    private var totalCorrectAnswers: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private var totalQuestions: Int {
        get {
            userDefaults.integer(forKey: Keys.totalAnswers.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalAnswers.rawValue)
        }
    }
}

// MARK: - StatisticServiceProtocol
extension StatisticServiceImplementation: StatisticServiceProtocol {
    
    // MARK: - Implementation of the protocol
    private(set) var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        bestGame = GameRecord(correct: count, total: amount, date: Date())
    }
    
    func updateStatisticService(correct: Int, amount: Int) {
        gamesCount += 1
        totalCorrectAnswers += correct
        totalQuestions += amount
        totalAccuracy = Double(totalCorrectAnswers) / Double(totalQuestions) * 100
    }
}
