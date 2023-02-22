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
    
    
    func getQuestions() {
        
        // Fetch the questions
        getLocalJsonFile()
        
        // TODO: Notify the delegate of the retrieved questions
        
    }
       // Fetch the new question data json file added
    func getLocalJsonFile() {
        
        // get path for local json file
        let path = Bundle.main.path(forResource: "NewQuestionData", ofType: ".json")
        
        // Double check the path isnt nil
        

        
        guard let path = path  else {
            print("Could not locate path to json file ")
            return
        }
        
        // Create a URL object from the path
        let url = URL(fileURLWithPath: path)
        
        do {
            // Get data from URL
            let data = try Data(contentsOf: url)
            
            
            // Try to decode the data into objects
            let decoder = JSONDecoder()
            let array   = try decoder.decode([Question].self, from: data)
            
            //  Notify the delegate of the parsed objects
            delegate?.questionsRetrieved((array))

        }
        catch {
            // Error: Couldn't read/download the data at that URL
        }
    }
}
