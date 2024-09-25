//
//  MovieViewModel.swift
//  Cinema_Trivia
//
//  Created by Artem on 26.08.2024.
//

import Foundation

struct Movie: Codable {
    
    enum CodingKeys: CodingKey {
        case id, title, year, image, imDbRating
    }
    
    enum ParseError: Error {
        case yearFailure
        case imDbRatingFailure
        
    }
    
    let id: String
    let title: String
    let year: Int
    let image: String
    let imDbRating: Double
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        let year = try container.decode(String.self, forKey: .year)
        guard let yearValue = Int(year) else { throw ParseError.yearFailure }
        self .year = yearValue
        
        self.image = try container.decode(String.self, forKey: .image)
        
        let imDbRating = try container.decode(String.self, forKey: .imDbRating)
        guard let imDbRatingValue = Double(imDbRating) else { throw ParseError.imDbRatingFailure }
        self.imDbRating = imDbRatingValue
    }
}

