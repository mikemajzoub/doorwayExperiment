//
//  CivicsQuestion.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/31/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

class CivicsQuestion: NSObject
{
    let question: String
    let answersSpoken: [String]
    let answersKeywords: [ [String] ]
    
    var totalCount: Int = 0
    var correctCount: Int = 0
    var weight: Int = 256
    
    init(question: String, answersSpoken: [String], answersKeywords: [ [String] ])
    {
        self.question = question
        self.answersSpoken = answersSpoken
        self.answersKeywords = answersKeywords
        
        super.init()
    }
    
    func correctlyAnswered()
    {
        totalCount++
        correctCount++
        
        weight /= 2
        
    }
    
    func incorrectlyAnswered()
    {
        totalCount++
        
        weight *= 2
    }
    
    func isMastered() -> Bool
    {
        let percentMastered = Float(correctCount) / Float(totalCount)
        
        return percentMastered > 0.2
    }
}