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
    
    // MARK: - Init
    init(question: String, answersSpoken: [String], answersKeywords: [ [String] ])
    {
        self.question = question
        self.answersSpoken = answersSpoken
        self.answersKeywords = answersKeywords
        
        super.init()
    }
    
    // MARK: - Encode/Decode
    required init(coder aDecoder: NSCoder)
    {
        question = aDecoder.decodeObjectForKey("Question") as! String
        answersSpoken = aDecoder.decodeObjectForKey("AnswersSpoken") as! [String]
        answersKeywords = aDecoder.decodeObjectForKey("AnswersKeywords") as! [ [String] ]
        
        totalCount = aDecoder.decodeIntegerForKey("TotalCount")
        correctCount = aDecoder.decodeIntegerForKey("CorrectCount")
        weight = aDecoder.decodeIntegerForKey("Weight")
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(question, forKey: "Question")
        aCoder.encodeObject(answersSpoken, forKey: "AnswersSpoken")
        aCoder.encodeObject(answersKeywords, forKey: "AnswersKeywords")
        
        aCoder.encodeInteger(totalCount, forKey: "TotalCount")
        aCoder.encodeInteger(correctCount, forKey: "CorrectCount")
        aCoder.encodeInteger(weight, forKey: "Weight")
    }
    
    // MARK: - Logic
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
        
        return percentMastered > 0.6
    }
}