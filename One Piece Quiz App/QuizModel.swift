//
//  QuizModel.swift
//  One Piece Quiz App
//
//  Created by Montana  on 2/7/23.
//

import Foundation

protocol QuizProtocol {
    
    // This will allow us to pass a parameter of  questions back and type in an array
    func questionsRetrieved(_ questions: [Question])
    
}

class QuizModel {
    //  QuizModel needs a delegate property to satisfy the protocol, type will be QuizProtocol, and optional, either no delegate or assigend as deletgate

    var delegate: QuizProtocol?
    
           //  TODO: Fetch Questions
    
          //   TODO: Notify the delegate of the retrieved questios
    
    func getQuestions() {
        
        // TODO: Fetch the questions
        
        // TODO: Notify the delegate of the retrieved questions
        
        // If the delegate cant retrieve questions, questionsRetrieved would get ignored safely.
        delegate?.questionsRetrieved([Question]())
        
    }
}
