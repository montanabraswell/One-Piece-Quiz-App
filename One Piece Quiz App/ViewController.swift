//
//  ViewController.swift
//  One Piece Quiz App
//
//  Created by Montana  on 2/2/23.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource, ResultViewControllerProtocol {
    
    
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
    
    
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var containerViewTrailingConstraint: NSLayoutConstraint!
    
    var resultDialog:ResultViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the result dialog
        resultDialog = storyboard?.instantiateViewController(withIdentifier: "ResultVC") as?  ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
        
        
        // Set self as the delegate and datasource for the tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        // In viewDidLoad, it will call model.getQuestions
        // Kicks off process for the quizModel to fetch the questions
        // Assigning view controller as the delegate
        model.delegate = self
        model.getQuestions()
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // Decrement the counter
       // milliseconds -= 1
        
        // Update the label
        //let seconds:Double = Double(milliseconds)/1000.0
        //timerLabel.text = String(format: "%.2f", seconds)
        
        // Stop the timer if it reaches zero
        //if milliseconds == 0 {
           // timer?.invalidate()
            
            // TODO: Check if user has answered the question
        }
        
    //}
    
    
    func slideInQuestion() {
        
        // Set the initial state
        containerViewTrailingConstraint.constant = 1000
        containerViewLeadingConstraint.constant = 1000
        view.layoutIfNeeded()
        
        
        // Animate it to the end state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.containerViewLeadingConstraint.constant = 0
            self.containerViewTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    func slideOutQuestion() {
        
        // Set the initial state
        containerViewTrailingConstraint.constant = 0
        containerViewLeadingConstraint.constant = 0
        view.layoutIfNeeded()
        
        
        // Animate it to the end state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.containerViewLeadingConstraint.constant = -1000
            self.containerViewTrailingConstraint.constant = -1000
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
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
        
        // Animate the question in
        slideInQuestion()
        
    }
    // MARK: - QuizProtocol Methods
    
    func questionsRetrieved(_ questions: [Question]) {
        
        // Get a reference to the questions
        self.questions = questions
        
        // Check if we shoudl restore the state, before showing question #1
        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < self.questions.count {
            
       //  Set the current question to the saved index
            currentQuestionIndex = savedIndex!
            
      // Retrieve the number correct from storage
           let savedNumCorrect =  StateManager.retrieveValue(key: StateManager.numCorrectKey) as? Int
            
            if savedNumCorrect != nil {
                numCorrect = savedNumCorrect!
            }
        }
        
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
        
        var titleText = ""
        
        // User has tapped on a row, check if it's the right answer
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex! == indexPath.row {
            // User got it right
            print(" User got it right!")
            
            titleText = "Correct!"
            numCorrect += 1
        }
        else {
            // User got it wrong
            print(" User got it wrong!")
            
            titleText = "Incorrect!"
        }
        // Slide out the question
        DispatchQueue.main.async {
            self.slideOutQuestion()
        }
        
        // Show the popup
        if let resultDialog = resultDialog {
            
            // Customize the dialog text
            resultDialog.titleText = titleText
            resultDialog.feedbackText = question.feedback!
            resultDialog.buttonText = "Next"
            
            DispatchQueue.main.async {
                self.present(resultDialog, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - ResultViewController Protocol Methods
    
    func dialogDimissed() {
        
        // Increment the currentQuestionIndex
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            
            // User has just answered the last question
            // Show a summary dialog
            
            if let resultDialog = resultDialog {
                
                // Customize the dialog text
                resultDialog.titleText = "Summary"
                resultDialog.feedbackText = "You got \(numCorrect) correct out of \(questions.count) questions"
                resultDialog.buttonText = "Restart"
                
                present(resultDialog, animated: true, completion: nil)
                
                // Clear state
                StateManager.clearState()
    
            }
            
        }
        else if currentQuestionIndex > questions.count {
            
            // Restart
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
        }
        else if currentQuestionIndex < questions.count {
            
            // We have more questions to show
            
            // Display next question
            displayQuestion()
            
            // Save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
        
    }
}
