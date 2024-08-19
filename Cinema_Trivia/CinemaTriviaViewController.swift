//
//  ViewController.swift
//  Cinema_Trivia
//
//  Created by Artem on 31.07.2024.
//

import UIKit

class CinemaTriviaViewController: UIViewController {
    
    private let movieRating = (3...9).randomElement()
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "IMG_7000", text: "Рейтинг этого фильма больше чем 6", correctAnswer: true),
        QuizQuestion(image: "IMG_7001", text: "Рейтинг этого фильма больше чем 6", correctAnswer: false),
        QuizQuestion(image: "profileImage", text: "Рейтинг этого фильма больше чем 6", correctAnswer: true),
    ]
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
//    MARK: - UI
    
    private lazy var questionLabel: UILabel = {
        .configure(view: $0) { label in
            label.text = "Вопрос:"
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            label.textColor = .white
        }
    }(UILabel())
    
    private lazy var counterLabel: UILabel = {
        .configure(view: $0) { label in
            label.text = "\(self.currentQuestionIndex + 1)/\(self.questionsAmount)"
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            label.textColor = .white
        }
    }(UILabel())
    
    private lazy var questionPosterImage: UIImageView = {
        .configure(view: $0) { image in
            image.layer.masksToBounds = true
            image.backgroundColor = .lightGray
            image.layer.cornerRadius = 16
            image.contentMode = .scaleAspectFill
        }
    }(UIImageView())
    
    private lazy var ratingQuestionTitleLabel: UILabel = {
        .configure(view: $0) { [weak self] label in
            guard let self else { return }
            label.text = "Рейтинг этого фильма больше чем \(String(describing: self.movieRating ?? 0))?"
            label.font = UIFont.systemFont(ofSize: 23, weight: .medium)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = .white

        }
    }(UILabel())
    
    private lazy var yesButton: UIButton = {
        .configure(view: $0) { button in
            button.widthAnchor.constraint(equalToConstant: 157).isActive = true
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            button.backgroundColor = .white
            button.setTitle("ДА", for: .normal)
            button.setTitleColor(.ctBlack, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
            button.layer.cornerRadius = 16
        }
    }(UIButton(primaryAction: yesButtonAction))
    
    private lazy var noButton: UIButton = {
        .configure(view: $0) { button in
            button.widthAnchor.constraint(equalToConstant: 157).isActive = true
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            button.backgroundColor = .white
            button.setTitle("НЕТ", for: .normal)
            button.setTitleColor(.ctBlack, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
            button.layer.cornerRadius = 16

        }
    }(UIButton(primaryAction: noButtonAction))
    
    private lazy var questionStack: UIStackView = {
        .configure(view: $0) { [weak self] stack in
            guard let self else { return }
            stack.axis = .horizontal
            stack.spacing = 10
            stack.distribution = .equalSpacing
            [self.questionLabel, self.counterLabel].forEach {
                stack.addArrangedSubview($0)
            }
        }
    }(UIStackView())
    
    private lazy var vStack: UIStackView = {
        .configure(view: $0) { [weak self] stack in
            guard let self else { return }
            stack.backgroundColor = .ctBlack
            stack.axis = .vertical
            stack.spacing = 20
            stack.layer.cornerRadius = 16
            [questionStack, self.questionPosterImage, self.ratingQuestionTitleLabel, buttonStack].forEach {
                stack.addArrangedSubview($0)
            }
        }
    }(UIStackView())
    
    private lazy var buttonStack: UIStackView = {
        .configure(view: $0) { [weak self] stack in
            guard let self else { return }
            stack.axis = .horizontal
            stack.spacing = 20
            stack.distribution = .fillEqually
            [self.yesButton, self.noButton].forEach {
                stack.addArrangedSubview($0)
            }
        }
    }(UIStackView())
    
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ctBlack
        
        [vStack].forEach {
            view.addSubview($0)
        }
        setupConstraint()
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    lazy var yesButtonAction = UIAction { [weak self] _ in
        self?.yesButtonTapped()
    }
    
    lazy var noButtonAction = UIAction { [weak self] _ in
        self?.noButtonTapped()
    }
    
    func yesButtonTapped() {
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer)
        show(quiz: convert(model: questions[currentQuestionIndex]))
        
    }
    
    func noButtonTapped() {
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer)
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
//    MARK: - PrivateMethods
    private func show(quiz step: QuizStepViewModel) {
        let currentQuestion = questions[currentQuestionIndex]
        let convert = convert(model: currentQuestion)
        questionPosterImage.image = convert.image
            
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default) {[weak self] _ in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            show(quiz: convert(model: firstQuestion))
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/ \(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        questionPosterImage.layer.borderWidth = 4
        questionPosterImage.layer.cornerRadius = 16
        questionPosterImage.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат \(correctAnswers) из \(questions.count)"
            let viewModel = QuizResultViewModel(title: "Этот раунд окончен!",
                                                text: text,
                                                buttonText: "Сыграть ещё раз?")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
        questionPosterImage.layer.borderColor = UIColor.clear.cgColor
    }
                                 
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
        
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            vStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        
            buttonStack.heightAnchor.constraint(equalToConstant: 60),

        ])
        
        let aspectRation = NSLayoutConstraint(item: questionPosterImage,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: questionPosterImage,
                                              attribute: .height,
                                              multiplier: 2/3,
                                              constant: 0)
        aspectRation.isActive = true
    }
}
