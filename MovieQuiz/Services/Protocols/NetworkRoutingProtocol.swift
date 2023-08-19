//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 19.08.2023.
//

import Foundation

protocol NetworkRoutingProtocol {
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
