//
//  ResultViewController.swift
//  One Piece Quiz App
//
//  Created by Montana  on 3/26/23.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Now that the elements have loaded, set the text
        
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for:  .normal)

    }
    
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        // TODO: dismiss the popup
        
    }
    
}
