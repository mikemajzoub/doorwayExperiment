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
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        openEarsEngine.delegate = self
        
        beginPractice()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        openEarsEngine.stopEngine()
    }
    
    func beginPractice()
    {
        askQuestion()
    }
    
    // Grab next question, speak it, and begin listening for user's answer
    func askQuestion()
    {
        dataModel.readingQuestionBank.refreshActiveBoundaryIndex()
        
        if let question = dataModel.readingQuestionBank?.nextQuestion()
        {
            questionCycleIsFinishing = false
            
            currentQuestion = question
            
            textToRead.text = question
            
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
            dataModel.readingQuestionBank.updateWordsForSpokenResponse(heardWords, forSentencePrompt: currentQuestion)
            
            var response = (heardWords == currentQuestion) ? "Correct. " : "Incorrect. The correct answer is. "
            response += currentQuestion
            openEarsEngine.say(response)
            
            questionCycleIsFinishing = true
        }
    }
    
    func computerFinishedSpeaking()
    {
        if questionCycleIsFinishing
        {
            askQuestion()
        }
    }
    
    func computerPausedListening()
    {
        
    }
    
    func computerResumedListening()
    {
        
    }
}