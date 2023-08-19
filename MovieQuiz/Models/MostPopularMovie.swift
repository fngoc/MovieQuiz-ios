//
//  MostPopularMovie.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 19.08.2023.
//

import Foundation

struct MostPopularMovie: Codable {
    
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString

        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"

        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.rating = try container.decode(String.self, forKey: .rating)
        self.imageURL = try container.decode(URL.self, forKey: .imageURL)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
