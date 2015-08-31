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
    let answer: [String]
    
    var totalCount: Int = 0
    var correctCount: Int = 0
    var weight: Float = 256.0
    
    init(question: String, answer: [String])
    {
        self.question = question
        self.answer = answer
        
        super.init()
    }
    
    func correctlyAnswered()
    {
        totalCount++
        correctCount++
        
        weight *= 0.5
        
    }
    
    func incorrectlyAnswered()
    {
        totalCount++
        
        weight *= 2
    }
}