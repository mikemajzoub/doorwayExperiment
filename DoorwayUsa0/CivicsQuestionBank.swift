//
//  CivicsQuestionBank.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/31/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

class CivicsQuestionBank
{
    var questions = [CivicsQuestion]()
    var activeBoundaryIndex: Int = 3 // as user masters more questions, introduce new ones
    
    init()
    {
        loadQuestions()
        printQuestions()
    }
    
    func update()
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
    
    func nextQuestion() -> CivicsQuestion?
    {
        var totalWeight = 0
        
        for index in 0..<activeBoundaryIndex
        {
            let q = questions[index]
            totalWeight += q.weight
        }
        
        
        let random = Int(arc4random_uniform(UInt32(totalWeight)))
        
        
        // get question
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
    
    func loadQuestions()
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
        answersKeywords: [ ["TWENTY", "SEVEN"] ])
        questions.append(question)
    }
}