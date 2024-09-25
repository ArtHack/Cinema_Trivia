//
//  QuestionFactoryDelegate.swift
//  Cinema_Trivia
//
//  Created by Artem on 20.08.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
