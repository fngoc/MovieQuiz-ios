//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 12.07.2023.
//

import UIKit

final class AlertPresenter {
    
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
}

// MARK: - AlertPresenterProtocol
extension AlertPresenter: AlertPresenterProtocol {
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.text,
            message: model.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        (delegate as? UIViewController)?.present(alert, animated: true, completion: nil)
    }
}
