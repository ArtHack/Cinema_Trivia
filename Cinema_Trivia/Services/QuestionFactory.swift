//
//  QuestionFactory.swift
//  Cinema_Trivia
//
//  Created by Artem on 19.08.2024.
//

import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    func loadData()
    func requestNextQuestion()
}

final class QuestionFactory: QuestionFactoryProtocol {

    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(image: "IMG_7000", text: "Рейтинг этого фильма больше чем 6", correctAnswer: true),
//        QuizQuestion(image: "IMG_7001", text: "Рейтинг этого фильма больше чем 6", correctAnswer: false),
//        QuizQuestion(image: "profileImage", text: "Рейтинг этого фильма больше чем 6", correctAnswer: true),
//    ]
    
    private var movies:[MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let randomNumber = (7...9).randomElement()
            let text = "Рейтинг этого фильма больше чем \(randomNumber ?? 0) ?"
            let correctAnswer = rating < Float(randomNumber ?? 0)
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
