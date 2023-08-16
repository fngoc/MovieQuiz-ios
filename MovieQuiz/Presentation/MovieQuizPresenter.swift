//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Виталий Хайдаров on 16.08.2023.
//

import UIKit

final class MovieQuizPresenter {
    
    private var correctAnswer: Int = 0
    
    private let questionAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    
    private weak var controller: MovieQuizViewControllerProtocol?
    
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    init(controller: MovieQuizViewControllerProtocol) {
        self.controller = controller
        
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: NetworkClient()), delegate: self)
        self.statisticService = StatisticServiceImplementation()
        
        self.questionFactory?.loadData()
        self.controller?.showLoadingIndicator()
    }
    
    func noButtonAction(_ sender: UIButton) {
        didAnswer(isYes: false)
    }
    
    func yesButtonAction(_ sender: UIButton) {
        didAnswer(isYes: true)
    }

    func reloadGame() {
        resetQuestionIndex()
        resetCorrectAnswer()
        questionFactory?.loadData()
    }
    
    func restartGame() {
        resetQuestionIndex()
        resetCorrectAnswer()
        questionFactory?.requestNextQuestion()
    }
    
    func makeMessage() -> String {
        guard let gamesCount = statisticService?.gamesCount,
              let recordCount = statisticService?.bestGame.correct,
              let recordTotal = statisticService?.bestGame.total,
              let recordTime = statisticService?.bestGame.date.dateTimeString,
              let average = statisticService?.totalAccuracy else {
            return "Ошибка при формировании сообщения"
        }
        
        let message = "Ваш результат: \(correctAnswer)/\(questionAmount)\n"
            .appending("Количество сыгранных квизов: \(gamesCount)\n")
            .appending("Рекорд: \(recordCount)/\(recordTotal) (\(recordTime))\n")
            .appending("Средняя точность \(String(format: "%.2f", average))%")
        return message
    }
    
    func updateStatisticService() {
        statisticService?.updateStatisticService(correct: correctAnswer, amount: questionAmount)
        let gameRecord = GameRecord(correct: correctAnswer, total: questionAmount, date: Date())
        
        if let bestGame = statisticService?.bestGame,
            gameRecord > bestGame {
            statisticService?.store(correct: correctAnswer, total: questionAmount)
        }
    }
    
    // MARK: - Private functions
    private func didAnswer(isYes: Bool) {
        controller?.setUnavailableButtons()
        proceedWithAnswer(isCorrect: currentQuestion?.correctAnswer == isYes)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)"
        )
        return viewModel
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            controller?.showResult()
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        controller?.highlightImageBorder(isCorrectAnswer: isCorrect)
        didAnswer(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            self.controller?.setAvailableButtons()
        }
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        correctAnswer = isCorrectAnswer ? correctAnswer + 1 : correctAnswer
    }
    
    private func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    private func resetCorrectAnswer() {
        correctAnswer = 0
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func isLastQuestion() -> Bool {
        return currentQuestionIndex == questionAmount - 1
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question;
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.controller?.show(quiz: viewModel)
        }
        controller?.removeStrokeAroundImage()
        controller?.show(quiz: viewModel)
    }
    
    func didLoadDataFromServer() {
        controller?.hideLoadingIndicator()
        controller?.setAvailableButtons()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        controller?.setUnavailableButtons()
        controller?.showNetworkError(message: error.localizedDescription)
    }
}
