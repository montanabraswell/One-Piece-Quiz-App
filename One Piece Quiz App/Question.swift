//
//  Question.swift
//  One Piece Quiz App
//
//  Created by Montana  on 2/7/23.
//

import Foundation

struct Question: Codable {
    
    // declaring properties
    var question: String?
    var answers: [String]?
    var correctAnswerIndex: Int?
    var feedback: String?
    
}
