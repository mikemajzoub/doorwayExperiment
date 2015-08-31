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
        
        for index in 0...activeBoundaryIndex
        {
            let question = questions[index]
            
            if !question.isMastered()
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
            println("q: \(q.question), a: \(q.answer)")
        }
    }
    
    func loadQuestions()
    {
        var question: CivicsQuestion
        
        question = CivicsQuestion(
            question: "say one or two",
            answer: ["one", "two"])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "say two or three",
            answer: ["two", "three"])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "say three or four",
            answer: ["three", "four"])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "say four or five",
            answer: ["four", "five"])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "say five or six",
            answer: ["five", "six"])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "say six or seven",
            answer: ["six", "seven"])
        questions.append(question)
        
        question = CivicsQuestion(
            question: "say seven or eight",
            answer: ["seven", "eight"])
        questions.append(question)
    }
}