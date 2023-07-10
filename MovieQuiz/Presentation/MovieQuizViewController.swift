import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var yesButtonView: UIButton!
    @IBOutlet private weak var noButtonView: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    
    private let questionAmount: Int = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true // Даём разрешение на рисование рамки
        imageView.layer.cornerRadius = 20.0
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        return viewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            if let currentQuestion = questionFactory.requestNextQuestion() {
                self.currentQuestion = currentQuestion
                let viewModel = convert(model: currentQuestion)
                self.show(quiz: viewModel)
            }
        }
        alert.addAction(action)
        super.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8.0 // Добавляю обводку вокруг картинки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        correctAnswer = isCorrect ? correctAnswer + 1 : correctAnswer
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0 // Убираю обводку вокруг картинки
            self.showNextQuestionOrResults()
            self.setAvailableButtons()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionAmount - 1 {
            show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: "Ваш результат: \(correctAnswer)/\(questionAmount)",
                buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionIndex += 1
            if let currentQuestion = questionFactory.requestNextQuestion() {
                self.currentQuestion = currentQuestion
                let viewModel = convert(model: currentQuestion)
                show(quiz: viewModel)
            }
        }
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
    
    @IBAction private func noButtonAction(_ sender: UIButton) {
        setUnavailableButtons()
        guard let currentQuestion = questionFactory.requestNextQuestion() else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    @IBAction private func yesButtonAction(_ sender: UIButton) {
        setUnavailableButtons()
        guard let currentQuestion = questionFactory.requestNextQuestion() else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
}
