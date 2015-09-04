//
//  CivicsQuestionBank.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/31/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

class CivicsQuestionBank: NSObject, NSCoding
{
    // This contains every civics question.
    var questions = [CivicsQuestion]()
    
    // The activeBoundaryIndex is what keeps the user from being overwhelmed with too
    // many new questions at once. It starts by only quizzing user on X questions,
    // and once the user has mastered these, it will quiz user on X + Y questions.
    // It will continue this pattern of increasing the questions can be randomly
    // selected until the entire question bank is revealed to the user.
    var activeBoundaryIndex = 3
    
    // MARK: - Init
    override init()
    {
        super.init()
        
    }
    
    required init(coder aDecoder: NSCoder)
    {
        questions = aDecoder.decodeObjectForKey("Questions") as! [CivicsQuestion]
        activeBoundaryIndex = aDecoder.decodeIntegerForKey("ActiveBoundaryIndex")
        
        super.init()
    }
    
    // MARK: - Save
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(questions, forKey: "Questions")
        aCoder.encodeInteger(activeBoundaryIndex, forKey: "ActiveBoundaryIndex")
    }
    
    // MARK: - Logic
    
    // The refreshActiveBoundaryIndex() will check each of the actively quizzed 
    // questions to see if the user has mastered each of them. If she has, it
    // will increase the activeBoundaryIndex by X so that the next time a
    // question is randomly selected, there will be new possible questions that
    // can be selected.
    func refreshActiveBoundaryIndex()
    {
        var allMastered = true
        
        for index in 0..<activeBoundaryIndex
        {
            let q = questions[index]
                        
            if !q.isMastered()
            {
                allMastered = false
                
                break
            }
        }
        
        if allMastered
        {
            activeBoundaryIndex += 3
            
            if activeBoundaryIndex > questions.count
            {
                activeBoundaryIndex = questions.count
            }
        }
    }
    
    // Randomly selects the next question for the user to answer from the 
    // available questions (determined by the activeBoundaryIndex). Note
    // that questions with large weights have a higher probability of being
    // selected.
    func nextQuestion() -> CivicsQuestion?
    {
        var totalWeight = 0
        
        for index in 0..<activeBoundaryIndex
        {
            let q = questions[index]
            totalWeight += q.weight
        }
        
        let random = Int(arc4random_uniform(UInt32(totalWeight)))
        
        var currentWeightSum = 0
        var questionToReturn: CivicsQuestion?
        
        for q in questions
        {
            currentWeightSum += q.weight
            
            if random < currentWeightSum
            {
                questionToReturn = q
                break
            }
        }
        
        return questionToReturn
    }
    
    func printQuestions()
    {
        for q in questions
        {
            println("q: \(q.question)\naSpoken: \(q.answersSpoken)\naKeywords: \(q.answersKeywords)")
        }
    }
    
    func percentMastered() -> Float
    {
        let allQuestions = questions.count
        var correctQuestions = 0
        
        for q in questions
        {
            if q.isMastered()
            {
                correctQuestions++
            }
        }
        
        let percentMastered = Float(correctQuestions) / Float(allQuestions)
        println("percent mastered: \(percentMastered)")
        
        return percentMastered
    }
    
    func generateLanguage() -> [String]
    {
        var language = [String]()
        
        for q in questions
        {
            language += q.answersSpoken
        }
        
        return language
    }
    
    // MARK: - Questions
    
    // If app is running for first time, initialize questions here.
    func initializeQuestions()
    {
        var question: CivicsQuestion
        
        question = CivicsQuestion(
            question: "what is the supreme law of the land?",
            answersSpoken: ["THE CONSTITUTION"],
            answersKeywords: [ ["CONSTITUTION"] ])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "What does the Constitution do?",
            answersSpoken: ["SETS UP THE GOVERNMENT", "DEFINES THE GOVERNMENT", "PROTECTS BASIC RIGHTS OF AMERICANS"],
            answersKeywords:[ ["SETS", "UP", "GOVERNMENT"], ["DEFINES", "GOVERNMENT"], ["PROTECTS", "RIGHTS", "AMERICANS"] ])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "The idea of self government is in the first three words of the Constitution. What are these three words?",
            answersSpoken: ["WE THE PEOPLE"],
            answersKeywords: [ ["WE", "THE", "PEOPLE"] ])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "What is an ammendment?",
            answersSpoken: ["A CHANGE TO THE CONSTITUTION", "AN ADDITION TO THE CONSTITUTION"],
        answersKeywords: [ ["CHANGE", "CONSTITUTION"], ["ADDITION", "CONSTITUTION"] ])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "What do we call the first ten ammendments to the Constitution",
            answersSpoken: ["THE BILL OF RIGHTS"],
        answersKeywords: [ ["BILL", "RIGHTS"] ])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "What is one right or freedom from the First Ammendment?",
            answersSpoken: ["SPEECH", "RELIGION", "ASSEMBLY", "PRESS", "PETITION THE GOVERNMENT"],
        answersKeywords: [ ["SPEECH"], ["RELIGION"], ["ASSEMBLY"], ["PRESS"], ["PETITION", "GOVERNMENT"] ])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "How many ammendments does the Constitution have?",
            answersSpoken: ["TWENTY-SEVEN"],
        answersKeywords: [ ["TWENTY-SEVEN"] ])
        questions.append(question)
    }
}