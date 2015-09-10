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
    @IBOutlet weak var replayAnswerButton: UIButton!
    
    // Whenever computer finishes speaking, it checks to see if the question
    // cycle is finishing. If the cycle is marked as finishing, it means that
    // it is time to choose a new question for the user. 
    //
    // If the cycle is NOT marked as finishing, it means that the computer just 
    // finished speaking a new question, and should not select another question 
    // yet.
    var questionCycleIsFinishing = false
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        openEarsEngine.delegate = self
        
        actionButton.setTitle("Play Question", forState: .Normal)
        actionButton.enabled = true
        replayAnswerButton.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        actionButton.enabled = true
        replayAnswerButton.hidden = true
        
        questionCycleIsFinishing = false
        
        openEarsEngine.stopEngine()
    }
    
    // Grab next question, speak it, and begin listening for user's answer
    @IBAction func askQuestion()
    {
        if let question = dataModel.civicsQuestionBank?.nextQuestion()
        {
            questionCycleIsFinishing = false

            currentQuestion = question
            
            openEarsEngine.say(question.question)
            openEarsEngine.startListening()
            
            actionButton.setTitle("Listen...", forState: .Disabled)
            actionButton.enabled = false
            replayAnswerButton.hidden = true
        }
    }
    
    @IBAction func replayAnswer()
    {
        replayAnswerButton.enabled = false
        actionButton.enabled = false
        
        let response = allPossibleAnswersResponse()
        
        openEarsEngine.say(response)
    }
    
    func allPossibleAnswersResponse() -> String
    {
        var response = ""
        
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
        
        return response
    }
    
    // MARK: - OpenEarsEngineDelegate
    
    // App has heard a completed answer. Will analyze accuracy and inform user of result.
    func heardWords(words: String!, withRecognitionScore recognitionScore: String!)
    {
        println("OpenEarsEngineDelegate heard: \(words), with score: \(recognitionScore)")
        
        openEarsEngine.stopListening()
        
        actionButton.setTitle("Listen...", forState: .Disabled)
        
        dataModel.civicsQuestionBank.gradeResponse(words, forQuestion: currentQuestion)
        
        let response: String
        if dataModel.civicsQuestionBank.answerIsCorrectForWords(words, forQuestion: currentQuestion)
        {
            let spokenCorrectAnswer = dataModel.civicsQuestionBank.answerToSpeakForWords(words, forQuestion: currentQuestion)
            response = "Correct. " + spokenCorrectAnswer
        }
        else
        {
            let allPossibleAnswers = allPossibleAnswersResponse()
            response = "Incorrect. " + allPossibleAnswers
        }
        
        openEarsEngine.say(response)
        
        questionCycleIsFinishing = true
    }
    
    func computerFinishedSpeaking()
    {
        if questionCycleIsFinishing
        {
            actionButton.enabled = true
            replayAnswerButton.hidden = false
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