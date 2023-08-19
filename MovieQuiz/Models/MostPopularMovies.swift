//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 28.07.2023.
//

import Foundation

struct MostPopularMovies: Codable {
    
    let errorMessage: String
    let items: [MostPopularMovie]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorMessage = try container.decode(String.self, forKey: .errorMessage)
        self.items = try container.decode([MostPopularMovie].self, forKey: .items)
    }
}
