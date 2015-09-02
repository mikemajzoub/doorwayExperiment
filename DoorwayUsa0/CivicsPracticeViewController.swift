//
//  CivicsPracticeViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/29/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class CivicsPracticeViewController: UIViewController, OpenEarsEngineDelegate
{
    var dataModel: DataModel!
    var openEarsEngine: OpenEarsEngine!
    
    var currentQuestion: CivicsQuestion!
    
    var questionCycleIsFinishing = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }
    
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
    
    func askQuestion()
    {
        dataModel.civicsQuestionBank.update()
        
        if let question = dataModel.civicsQuestionBank.nextQuestion()
        {
            questionCycleIsFinishing = false
            
            currentQuestion = question
            
            openEarsEngine.say(question.question)
            
            openEarsEngine.startListening()
        }
    }
    
    // OpenEarsEngineDelegate
    func heardWords(words: String!, withRecognitionScore recognitionScore: String!)
    {
        println("OpenEarsEngineDelegate heard: \(words), with score: \(recognitionScore)")
        
        openEarsEngine.stopListening()
        
        if let heardWords = words
        {
            var response: String
            
            if answerIsCorrectForWords(heardWords)
            {
                currentQuestion.correctlyAnswered()
                
                let answerToSpeak = answerToSpeakForWords(heardWords)
                
                response = "Correct. \(answerToSpeak)"
            }
            else
            {
                currentQuestion.incorrectlyAnswered()
                
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