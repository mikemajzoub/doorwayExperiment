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
    
    init()
    {
        loadQuestions()
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