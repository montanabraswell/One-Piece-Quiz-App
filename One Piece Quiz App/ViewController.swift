//
//  ViewController.swift
//  One Piece Quiz App
//
//  Created by Montana  on 2/2/23.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource {
 

    // Declare model property and initialize a new quiz model object
    var model = QuizModel()
    
    // When Quizmodel comes back with questions, need to keep track of them
    // Declare questions property and initialize with a new questions object but an empty array
    var questions = [Question]()
    
    // Keep track of which question the user is currently looking at
    var currentQuestionIndex = 0
    
    var numCorrect = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var resultDialog:ResultViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the result dialog
        resultDialog = storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        
        
        
        // Set self as the delegate and datasource for the tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        // In viewDidLoad, it will call model.getQuestions
        // Kicks off process for the quizModel to fetch the questions
        // Assigning view controller as the delegate
        model.delegate = self
        model.getQuestions()
    }
    
    func displayQuestion() {
    
        // Check if there are questions and check that the currentQuestionIndex is not out of bounds
        
        guard questions.count > 0  && currentQuestionIndex < questions.count else {
            return
        }
        
        // Display question text
        questionLabel.text = questions[currentQuestionIndex].question
        
        // Reload the tableview
        tableView.reloadData()
        
    }
    // MARK: - QuizProtocol Methods
    
    func questionsRetrieved(_ questions: [Question]) {
        
        // Get a reference to the questions
        self.questions = questions
        
        // Display the first question
        displayQuestion()
        
        
    }
    
    // MARK: -UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Make sure that the question array actually contains a question
        
        guard questions.count > 0 else {
            return 0
        }
        
        // Return the number of answers for this question
        let currentQuestion = questions[currentQuestionIndex]
        
    
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // Customize it
        if let label = cell.viewWithTag(1) as? UILabel {
            
            let question = questions[currentQuestionIndex]
            
            if let answers = question.answers, indexPath.row < answers.count {
                
                // Set the answer text to label
                label.text = answers[indexPath.row]
            }
            
        }
        
        // Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // User has tapped on a row, check if it's the right answer
        let question = questions[currentQuestionIndex]
        
        
        if question.correctAnswerIndex! == indexPath.row {
            
            // User got it right
            
            print(" User got it right!")
            
        }
        else {
            
            // User got it wrong
            
            print(" User got it wrong!")
        }
        
        // Show the popup
        
        if resultDialog != nil {
            present(resultDialog!, animated: true, completion: nil)
        }
        
        // Increment the currentQuestionIndex
        currentQuestionIndex += 1
        
        // Display next question
        displayQuestion()   
    }
    
  
}
