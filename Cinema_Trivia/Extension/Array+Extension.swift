//
//  Array+Extension.swift
//  Cinema_Trivia
//
//  Created by Artem on 19.08.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
