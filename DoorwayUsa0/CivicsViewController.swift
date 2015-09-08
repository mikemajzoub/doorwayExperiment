//
//  CivicsPracticeViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/29/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class CivicsViewController: UIViewController, OpenEarsEngineDelegate
{
    var dataModel: DataModel!
    var openEarsEngine: OpenEarsEngine!
    
    var currentQuestion: CivicsQuestion!
    
    @IBOutlet weak var actionButton: UIButton!
    
    // Whenever computer finishes speaking, it checks to see if the question
    // cycle is finishing. If the cycle is marked as finishing, it means that
    // it is time to choose a new question for the user. 
    //
    // If the cycle is NOT marked as finishing, it means that the computer just 
    // finished speaking a new question, and should not select another question 
    // yet.
    var questionCycleIsFinishing = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        openEarsEngine.delegate = self
        
        actionButton.setTitle("Play Question", forState: .Normal)
        actionButton.enabled = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        openEarsEngine.stopEngine()
    }
    
    // Grab next question, speak it, and begin listening for user's answer
    @IBAction func askQuestion()
    {
        dataModel.civicsQuestionBank.refreshActiveBoundaryIndex()
        
        if let question = dataModel.civicsQuestionBank.nextQuestion()
        {
            actionButton.setTitle("Listen...", forState: .Disabled)
            actionButton.enabled = false
            
            questionCycleIsFinishing = false
            
            currentQuestion = question
            
            openEarsEngine.say(question.question)
            
            openEarsEngine.startListening()
        }
    }
    
    // MARK: - OpenEarsEngineDelegate
    
    // App has heard a completed answer. Will analyze accuracy and inform user of result.
    func heardWords(words: String!, withRecognitionScore recognitionScore: String!)
    {
        println("OpenEarsEngineDelegate heard: \(words), with score: \(recognitionScore)")
        
        openEarsEngine.stopListening()
        
        actionButton.setTitle("Speak Now...", forState: .Disabled)
        
        if let heardWords = words
        {
            var response: String
            
            if answerIsCorrectForWords(heardWords)
            {
                currentQuestion.answeredCorrectly()
                
                let answerToSpeak = answerToSpeakForWords(heardWords)
                
                response = "Correct. \(answerToSpeak)"
            }
            else
            {
                currentQuestion.answeredIncorrectly()
                
                response = "Incorrect. "
                
                if currentQuestion!.answersSpoken.count == 1
                {
                    response += "The correct answer is \(currentQuestion!.answersSpoken[0])"
                }
                else
                {
                    response += "There are multiple correct answers. You could say "
                    
                    for (index, answer) in enumerate(currentQuestion!.answersSpoken)
                    {
                        response += answer
                        
                        if index != currentQuestion!.answersSpoken.count - 1
                        {
                            response += "... or you could say "
                        }
                    }
                }
            }
            
            openEarsEngine.say(response)
            
            questionCycleIsFinishing = true
        }
    }
    
    // TODO: refactor this into civics question bank...
    func answerIsCorrectForWords(heardWords: String) -> Bool
    {
        let heardWordsSet = Set(heardWords.componentsSeparatedByString(" "))
        
        let keywords = currentQuestion.answersKeywords
        for answerArray in keywords
        {
            let answerSet = Set(answerArray)
            
            if answerSet.isSubsetOf(heardWordsSet)
            {
                return true
            }
        }
        
        return false
    }
    
    func answerToSpeakForWords(heardWords: String) -> String
    {
        let heardWordsSet = Set(heardWords.componentsSeparatedByString(" "))
        
        let keywords = currentQuestion.answersKeywords
        for (index, answerArray) in enumerate(keywords)
        {
            let answerSet = Set(answerArray)
            
            if answerSet.isSubsetOf(heardWordsSet)
            {
                return currentQuestion.answersSpoken[index]
            }
        }
        
        return "ERROR FINDING ANSWER TO SPEAK"
    }
    
    func computerFinishedSpeaking()
    {
        if questionCycleIsFinishing
        {
            actionButton.enabled = true
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