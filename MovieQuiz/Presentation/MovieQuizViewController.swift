import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var yesButtonView: UIButton!
    @IBOutlet private weak var noButtonView: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true // Даём разрешение на рисование рамки
        imageView.layer.cornerRadius = 20.0
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel: QuizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
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
            self.show(quiz: self.convert(model: self.questions[self.currentQuestionIndex]))
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
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: "Ваш результат: \(correctAnswer)/\(questions.count)",
                buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]))
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
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == false)
    }
    
    @IBAction private func yesButtonAction(_ sender: UIButton) {
        setUnavailableButtons()
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == true)
    }
}
