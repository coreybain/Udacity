//
//  QuizViewController+Functions.swift
//  GeoQuiz
//
//  Created by Jarrod Parkes on 6/21/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// MARK: - QuizViewController (Functions)

extension QuizViewController {
  
    // MARK: QuizState
    
    enum QuizState {
        case NoQuestionUpYet, PlayingAudio, QuestionDisplayed, ReadyToSpeak
    }
    
    // MARK: Actions
    
    @IBAction func hearPhrase(sender: UITapGestureRecognizer) {
        // This function runs to code for when the button says "Hear Phrase" or when it says Stop.
        // The first check is to see if we are speaking, in which case the button would have been labeled STOP
        // If iOS is currently speaking we tell it to stop and reset the buttons
        if currentState == .PlayingAudio {
            stopAudio()
            resetButtonToState(.ReadyToSpeak)
        } else if currentState == .NoQuestionUpYet {
            // no Question so choose a language and question
            chooseNewLanguageAndSetupButtons()
            speak(spokenText, languageCode: bcpCode)
        } else if currentState == .QuestionDisplayed || currentState == .ReadyToSpeak {
            // Flags are up so just replay the audio
            speak(spokenText, languageCode: bcpCode)
        }
    }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        resetButtonToState(.NoQuestionUpYet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguages()
    }
    
    // MARK: Speak
    
    func speak(stringToSpeak: String, languageCode: String) {
        // Grab the Speech Synthesizer and set the language and text to speak
        // Tell it to call this ViewController back when it has finished speaking
        // Tell it to start speaking.
        // Finally, set the "Hear Phrase" button to say "Stop" instead
        speechSynth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: stringToSpeak)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        speechSynth.delegate = self
        speechSynth.speakUtterance(speechUtterance)
        resetButtonToState(.PlayingAudio)
    }
    
    func stopAudio() {
        // Stops the audio playback
        speechSynth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }

    // MARK: Setup/Reset
    
    func setupLanguages() {
        
        var tempCountry = Country()
        
        // Czech Language
        tempCountry = Country(name: "Czech", bcp47Code: "cs-CZ", textToRead: "Učení je celoživotní výkon.", flagImageName: "czechFlag")
        languageChoices.append(tempCountry)
        
        // Danish Language
        tempCountry = Country(name: "Danish", bcp47Code: "da-DK", textToRead: "Læring er en livslang stræben.", flagImageName: "denmarkFlag")
        languageChoices.append(tempCountry)
        
        // German Language
        tempCountry = Country(name: "German", bcp47Code: "de-DE", textToRead: "Lernen ist ein lebenslanger Verfolgung.", flagImageName: "germanyFlag")
        languageChoices.append(tempCountry)
        
        // Spanish Language
        tempCountry = Country(name: "Spanish", bcp47Code: "es-ES", textToRead: "El aprendizaje es una búsqueda que dura toda la vida.", flagImageName: "spainFlag")
        languageChoices.append(tempCountry)
        
        // French Language
        tempCountry = Country(name: "French", bcp47Code: "fr-FR", textToRead: "L'apprentissage est une longue quête de la vie.", flagImageName: "franceFlag")
        languageChoices.append(tempCountry)
        
        // Polish Language
        tempCountry = Country(name: "Polish", bcp47Code: "pl-PL", textToRead: "Uczenie się przez całe życie pościg.", flagImageName: "polandFlag")
        languageChoices.append(tempCountry)
        
        // English Language
        tempCountry = Country(name: "English", bcp47Code: "en-US", textToRead: "Learning is a life long pursuit.", flagImageName: "unitedStatesFlag")
        languageChoices.append(tempCountry)
        
        // Portuguese Language
        tempCountry = Country(name: "Portuguese", bcp47Code: "pt-BR", textToRead: "A aprendizagem é um longa busca que dura toda a vida.", flagImageName: "brazilFlag")
        languageChoices.append(tempCountry)
        
    }

    func chooseNewLanguageAndSetupButtons() {
        // 1. Choose the location of the correct answer
        // 2. Choose the language of the correct answer
        // 3. Choose the language of the other 2 answers (incorrect answers) array randomItem
        
        resetButtonToState(.ReadyToSpeak)
        // 1.
        let randomChoiceLocation = arc4random_uniform(UInt32(3))
        var button1: UITapGestureRecognizer!
        var button1Image: UIImageView!
        var button1Label: UILabel!
        var button2: UITapGestureRecognizer!
        var button2Image: UIImageView!
        var button2Label: UILabel!
        var button3: UITapGestureRecognizer!
        var button3Image: UIImageView!
        var button3Label: UILabel!
        
        if (randomChoiceLocation == 0) {
            print("Debug: Correct answer in the first, top button")
            button1 = flagButton1
            button1Image = flagButton1Image
            button1Label = flagButton1Label
            button2 = flagButton2
            button2Image = flagButton2Image
            button2Label = flagButton2Label
            button3 = flagButton3
            button3Image = flagButton3Image
            button3Label = flagButton3Label
            correctButtonTag = 0
        } else if (randomChoiceLocation == 1) {
            print("Debug: Correct answer is in the middle button")
            button1 = flagButton2
            button1Image = flagButton2Image
            button1Label = flagButton2Label
            button2 = flagButton1
            button2Image = flagButton1Image
            button2Label = flagButton1Label
            button3 = flagButton3
            button3Image = flagButton3Image
            button3Label = flagButton3Label
            correctButtonTag = 1
        } else {
            print("Debug: Correct answer is in the bottom button")
            button1 = flagButton3
            button1Image = flagButton3Image
            button1Label = flagButton3Label
            button2 = flagButton2
            button2Image = flagButton2Image
            button2Label = flagButton2Label
            button3 = flagButton1
            button3Image = flagButton1Image
            button3Label = flagButton1Label
            correctButtonTag = 2

        }
        
        // use vars button1-3 to assign the text.
        let randomLanguage = arc4random_uniform(UInt32(self.languageChoices.count))
        let randomLanguageInt = Int(randomLanguage)
        let correctCountry = languageChoices[randomLanguageInt]
        
        let languageTitle = correctCountry.languageName
        bcpCode = correctCountry.languageCode
        spokenText = correctCountry.textToSpeak
        //languageTitle = languageTitle + "CR"
        let button1Flag = correctCountry.flagName
        button1Label.text = languageTitle
        button1Image.image = UIImage(named: button1Flag)
        
        var otherChoicesArray = languageChoices
        otherChoicesArray.removeAtIndex(randomLanguageInt)
        
        let secondRandomLanguage = arc4random_uniform(UInt32(otherChoicesArray.count))
        let secondRandomLanguageInt = Int(secondRandomLanguage)
        let alternateCountry1 = otherChoicesArray[secondRandomLanguageInt]
        
        let secondLanguageTitle = alternateCountry1.languageName
        let button2Flag = alternateCountry1.flagName
        button2Label.text = secondLanguageTitle
        button2Image.image = UIImage(named: button2Flag)
        
        otherChoicesArray.removeAtIndex(secondRandomLanguageInt)
        
        let thirdRandomLanguage = arc4random_uniform(UInt32(otherChoicesArray.count))
        let thirdRandomLanguageInt = Int(thirdRandomLanguage)
        let alternateCountry2 = otherChoicesArray[thirdRandomLanguageInt]
        
        let thirdLanguageTitle = alternateCountry2.languageName
        let button3Flag = alternateCountry2.flagName
        button3Label.text = thirdLanguageTitle
        button3Image.image = UIImage(named: button3Flag)
        otherChoicesArray.removeAtIndex(thirdRandomLanguageInt)
    }
    
    func resetButtonToState(newState: QuizState) {
        if newState == .NoQuestionUpYet {
            flagButton1Image.alpha = 0.0
            flagButton1Label.alpha = 0.0
            flagButton1.enabled = false
            flagButton2Image.alpha = 0.0
            flagButton2Label.alpha = 0.0
            flagButton2.enabled = false
            flagButton3Image.alpha = 0.0
            flagButton3Label.alpha = 0.0
            flagButton3.enabled = false
            repeatPhraseButtonLabel.text = "Start Quiz"
        } else if newState == .ReadyToSpeak {
            repeatPhraseButtonLabel.text = "Hear Phrase"
        } else if newState == .QuestionDisplayed {
            repeatPhraseButtonLabel.text = "Hear phrase again"
        } else if newState == .PlayingAudio {
            flagButton1Image.alpha = 100.0
            flagButton1Label.alpha = 100.0
            flagButton1.enabled = true
            flagButton2Image.alpha = 100.0
            flagButton2Label.alpha = 100.0
            flagButton2.enabled = true
            flagButton3Image.alpha = 100.0
            flagButton3Label.alpha = 100.0
            flagButton3.enabled = true
            repeatPhraseButtonLabel.text = "Stop audio"
        }
        currentState = newState
    }
    
    // MARK: Alerts
    
    func resetQuiz(alert: UIAlertAction!) {
        chooseNewLanguageAndSetupButtons()
        resetButtonToState(.ReadyToSpeak)
    }
  
    func displayAlert(messageTitle: String, messageText: String) {
        stopAudio()
        let alert = UIAlertController(title: messageTitle, message:messageText, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: resetQuiz))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: - QuizViewController: AVSpeechSynthesizerDelegate

extension QuizViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
        resetButtonToState(.QuestionDisplayed)
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        resetButtonToState(.QuestionDisplayed)
    }
}