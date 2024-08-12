//
//  UIView+Extension.swift
//  Cinema_Trivia
//
//  Created by Artem on 09.08.2024.
//

import UIKit

extension UIView {
    static func configure<T: UIView>(view: T, completion: @escaping(T) -> ()) -> (T) {
        view.translatesAutoresizingMaskIntoConstraints = false
        completion(view)
        return view
    }
}
