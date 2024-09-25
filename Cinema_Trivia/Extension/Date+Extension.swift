//
//  Date+Extension.swift
//  Cinema_Trivia
//
//  Created by Artem on 26.08.2024.
//

import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YY hh:mm"
    return dateFormatter
}()

extension Date {
    var dateTimeString: String { dateTimeDefaultFormatter.string(from: self) }
}
