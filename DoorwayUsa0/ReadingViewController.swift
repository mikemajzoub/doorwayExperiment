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
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var replayAnswer: UIButton!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        openEarsEngine.delegate = self
        
        actionButton.setTitle("Play Question", forState: .Normal)
        actionButton.enabled = true
        
        replayAnswer.hidden = true
        
        textToRead.text = "" // clear out lorem ipsum.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        openEarsEngine.stopEngine()
        
        replayAnswer.hidden = true
    }
    
    // Grab next question, speak it, and begin listening for user's answer
    @IBAction func askQuestion()
    {
        dataModel.readingQuestionBank.refreshActiveBoundaryIndex()
        
        if let question = dataModel.readingQuestionBank?.nextQuestion()
        {
            replayAnswer.hidden = true
            
            actionButton.enabled = false
            
            questionCycleIsFinishing = false
            
            currentQuestion = question
            
            textToRead.text = question
            
            openEarsEngine.say("Please reed this sentence aloud.") // 'reed' is NOT a typo. OE pronounces 'read' like 'red'
            
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
            actionButton.setTitle("Listen...", forState: .Disabled)
            actionButton.enabled = false
            
            dataModel.readingQuestionBank.updateWordsForSpokenResponse(heardWords, forSentencePrompt: currentQuestion)
            
            // TODO: Reading needs to be a bit more forgiving. Perhaps break into 2 sets, and allow response to have 2 incorrect words?, etc.
            var response = (heardWords == currentQuestion) ? "Correct. " : "Incorrect. The correct answer is. "
            response += currentQuestion
            openEarsEngine.say(response)
            
            questionCycleIsFinishing = true
        }
    }
    
    @IBAction func repeatAnswer()
    {
        replayAnswer.hidden = true
        actionButton.enabled = false
        
        openEarsEngine.say(currentQuestion)
    }
    
    func computerFinishedSpeaking()
    {
        if questionCycleIsFinishing
        {
            actionButton.enabled = true
            replayAnswer.hidden = false
        }
        else
        {
            actionButton.setTitle("Speak Now...", forState: .Disabled)
        }
    }
    
    func computerPausedListening()
    {
        
    }
    
    func computerResumedListening()
    {
        
    }
}