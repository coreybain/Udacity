//
//  QuizViewController.swift
//  GeoQuiz
//
//  Created by Jarrod Parkes on 6/21/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - QuizViewController: UIViewController

class QuizViewController: UIViewController {
    
    
    // MARK: Outlets
    
    //Choice of country
    @IBOutlet var flagButton1: UITapGestureRecognizer!
    @IBOutlet var flagButton2: UITapGestureRecognizer!
    @IBOutlet var flagButton3: UITapGestureRecognizer!
    
    //Image of flag
    @IBOutlet weak var flagButton1Image: UIImageView!
    @IBOutlet weak var flagButton2Image: UIImageView!
    @IBOutlet weak var flagButton3Image: UIImageView!
    
    //Label of flag
    @IBOutlet weak var flagButton1Label: UILabel!
    @IBOutlet weak var flagButton2Label: UILabel!
    @IBOutlet weak var flagButton3Label: UILabel!
    
    // TapGestureRecognizer Views
    @IBOutlet weak var flag1: UIStackView!
    @IBOutlet weak var flag2: UIStackView!
    @IBOutlet weak var flag3: UIStackView!
    
    
    @IBOutlet var repeatPhraseButton: UITapGestureRecognizer!
    @IBOutlet weak var repeatPhraseButtonLabel: UILabel!
  
    // MARK: Properties
    
    var languageChoices = [Country]()
    var lastRandomLanguageID = -1
    var selectedRow = -1
    var correctButtonTag = -1
    var currentState: QuizState = .NoQuestionUpYet
    var spokenText = ""
    var bcpCode = ""
    let speechSynth = AVSpeechSynthesizer()
    
    // MARK: Actions
    
    // This function is called when user presses a flag button.
    @IBAction func flagButtonPressed(sender: UITapGestureRecognizer) {
        
        // TODO: Add code to display a message to the user telling them whether or not they guessed correctly.s
        if ((sender.view?.tag)! == correctButtonTag) {
            displayAlert("Correct", messageText: "Right On!")
        } else {
            displayAlert("Incorrect", messageText: "Nope. Try again")
        }
    }
}