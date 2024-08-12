//
//  ViewController.swift
//  Cinema_Trivia
//
//  Created by Artem on 31.07.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let movieRating = (3...9).randomElement()
    private let currentQuestion: Int = 1
    private let questionsAmount: Int = 10
    
//    MARK: - UI
    
    private lazy var questionLabel: UILabel = {
        .configure(view: $0) { label in
            label.text = "Вопрос:"
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            label.textColor = .white
        }
    }(UILabel())
    
    private lazy var counterLabel: UILabel = {
        .configure(view: $0) { [weak self] label in
            guard let self else { return }
            label.text = "\(self.currentQuestion)/\(self.questionsAmount)"
            label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            label.textColor = .white
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
    }(UILabel())
    
    private lazy var questionPosterImage: UIImageView = {
        .configure(view: $0) { image in
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
    }
    
    lazy var yesButtonAction = UIAction { [weak self] _ in
        self?.yesButtonTapped()
    }
    
    lazy var noButtonAction = UIAction { [weak self] _ in
        self?.noButtonTapped()
    }
    
    func yesButtonTapped() {
//        TODO
    }
    
    func noButtonTapped() {
//        TODO
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
        
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            vStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            buttonStack.heightAnchor.constraint(equalToConstant: 60),

        ])
        
    
        
        let aspectRatio = NSLayoutConstraint(item: questionPosterImage,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: questionPosterImage,
                                             attribute: .height,
                                             multiplier: 2.0/3.0,
                                             constant: 0)
        aspectRatio.isActive = true
    }
}
