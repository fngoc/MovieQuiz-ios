import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var yesButtonView: UIButton!
    @IBOutlet private weak var noButtonView: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()

        imageView.layer.masksToBounds = true // Даём разрешение на рисование рамки
        imageView.layer.cornerRadius = 20.0
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question;
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        self.imageView.layer.borderWidth = CGFloat.zero // Убираю обводку вокруг картинки
        show(quiz: viewModel)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        setAvailableButtons()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        setUnavailableButtons()
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegate
    func showResult() {
        statisticService?.updateStatisticService(correct: correctAnswer, amount: questionAmount)
        let gameRecord = GameRecord(correct: correctAnswer, total: questionAmount, date: Date())
        
        if let bestGame = statisticService?.bestGame,
            gameRecord > bestGame {
            statisticService?.store(correct: correctAnswer, total: questionAmount)
        }
        
        let alertModel = AlertModel(
            text: "Этот раунд окончен",
            message: makeMessage(),
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswer = 0
                self.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.showAlert(model: alertModel)
    }
    
    // MARK: - Private functions
    private func makeMessage() -> String {
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)"
        )
        return viewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8.0 // Добавляю обводку вокруг картинки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        correctAnswer = isCorrect ? correctAnswer + 1 : correctAnswer
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.setAvailableButtons()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionAmount - 1 {
            showResult()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel: AlertModel = AlertModel(
            text: "Ошибка",
            message: "Ошибка загрузки фильмов",
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswer = 0
                self.questionFactory?.loadData()
            })
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // Делаю кнопки не доступными, что бы избежать во время быстрого нажатия на кнопки быстрой смены вопросов
    private func setUnavailableButtons() {
        noButtonView.isUserInteractionEnabled = false
        yesButtonView.isUserInteractionEnabled = false
    }
    
    // Делаю кнопки доступными
    private func setAvailableButtons() {
        noButtonView.isUserInteractionEnabled = true
        yesButtonView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @IBAction private func noButtonAction(_ sender: UIButton) {
        setUnavailableButtons()
        showAnswerResult(isCorrect: self.currentQuestion?.correctAnswer == false)
    }
    
    @IBAction private func yesButtonAction(_ sender: UIButton) {
        setUnavailableButtons()
        showAnswerResult(isCorrect: self.currentQuestion?.correctAnswer == true)
    }
}
