//
//  ReadingViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/4/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class ReadingViewController: UIViewController, OpenEarsEngineDelegate
{
    var dataModel: DataModel!
    var openEarsEngine: OpenEarsEngine!
    
    var currentQuestion: String!
    
    var questionCycleIsFinishing = true
    
    @IBOutlet weak var textToRead: UITextView!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        openEarsEngine.delegate = self
        
        textToRead.text = "" // clear out lorem ipsum.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        openEarsEngine.stopEngine()
    }
    
    // Grab next question, speak it, and begin listening for user's answer
    @IBAction func askQuestion()
    {        
        if let question = dataModel.readingQuestionBank?.nextQuestion()
        {
            questionCycleIsFinishing = false
            
            currentQuestion = question
            
            textToRead.text = question
            
            openEarsEngine.say("Please reed this sentence aloud.") // 'reed' is NOT a typo. OpenEars pronounces 'read' like 'red'
            
            openEarsEngine.startListening()
        }
    }

    // MARK: - OpenEarsEngineDelegate

    // App has heard a completed answer. Will analyze accuracy and inform user of result.
    func heardWords(words: String!, withRecognitionScore recognitionScore: String!)
    {
        println("OpenEarsEngineDelegate heard: \(words), with score: \(recognitionScore)")
        
        openEarsEngine.stopListening()
        
        if let heardWords = words
        {
            questionCycleIsFinishing = true
            
            // grade the answer
            dataModel.readingQuestionBank.updateWordsForSpokenResponse(heardWords, forSentencePrompt: currentQuestion)

            // say the answer
            var response = dataModel.readingQuestionBank.isCorrectUserResponse(words, forAnswer: currentQuestion) ? "Correct. " : "Incorrect. The correct answer is. "
            response += currentQuestion
            openEarsEngine.say(response)
        }
    }
    
    @IBAction func replayAnswer()
    {
        openEarsEngine.say(currentQuestion)
    }
    
    func computerFinishedSpeaking()
    {
        if questionCycleIsFinishing
        {

        }
        else
        {

        }
    }
    
    func computerPausedListening()
    {
        
    }
    
    func computerResumedListening()
    {
        
    }
}