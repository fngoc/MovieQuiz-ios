import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var yesButtonView: UIButton!
    @IBOutlet private weak var noButtonView: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter?
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(controller: self)
        alertPresenter = AlertPresenter(delegate: self)

        imageView.layer.masksToBounds = true // Даём разрешение на рисование рамки
        imageView.layer.cornerRadius = 20.0
    }
    
    func removeStrokeAroundImage() {
        imageView.layer.borderWidth = CGFloat.zero
    }
    
    // Делаю кнопки не доступными, что бы избежать во время быстрого нажатия на кнопки быстрой смены вопросов
    func setUnavailableButtons() {
        noButtonView.isUserInteractionEnabled = false
        yesButtonView.isUserInteractionEnabled = false
    }
    
    // Делаю кнопки доступными
    func setAvailableButtons() {
        noButtonView.isUserInteractionEnabled = true
        yesButtonView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @IBAction private func noButtonAction(_ sender: UIButton) {
        presenter?.noButtonAction(sender)
    }
    
    @IBAction private func yesButtonAction(_ sender: UIButton) {
        presenter?.yesButtonAction(sender)
    }
}

// MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
    
    func showResult() {
        presenter?.updateStatisticService()
        
        let alertModel = AlertModel(
            text: "Этот раунд окончен",
            message: presenter?.makeMessage() ?? "Ошибка формирования статистики",
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter?.restartGame()
            })
        alertPresenter?.showAlert(model: alertModel)
    }
}

// MARK: - MovieQuizViewControllerProtocol
extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = 8.0 // Добавляю обводку вокруг картинки
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel: AlertModel = AlertModel(
            text: "Ошибка",
            message: "Ошибка загрузки фильмов",
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter?.reloadGame()
            })
        alertPresenter?.showAlert(model: alertModel)
    }
}
