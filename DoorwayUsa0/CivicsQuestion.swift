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
    // Question to be spoken by openEars.
    let question: String
    
    // Answers to be spoken by openEars.
    let answersSpoken: [String]
    
    // Required subset of words that must be said in order for answer to be marked correct.
    let answersKeywords: [ [String] ]
    
    // Decrease weight if answered correctly, increase if answered correctly.
    // This will determine probability of question being selected in future.
    var weight: Int = 256
    
    // MARK: - Init
    init(question: String, answersSpoken: [String], answersKeywords: [ [String] ])
    {
        self.question = question
        self.answersSpoken = answersSpoken
        self.answersKeywords = answersKeywords
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        question = aDecoder.decodeObjectForKey("Question") as! String
        answersSpoken = aDecoder.decodeObjectForKey("AnswersSpoken") as! [String]
        answersKeywords = aDecoder.decodeObjectForKey("AnswersKeywords") as! [ [String] ]
        
        weight = aDecoder.decodeIntegerForKey("Weight")
        
        super.init()
    }
    
    // MARK: - Save
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(question, forKey: "Question")
        aCoder.encodeObject(answersSpoken, forKey: "AnswersSpoken")
        aCoder.encodeObject(answersKeywords, forKey: "AnswersKeywords")
        
        aCoder.encodeInteger(weight, forKey: "Weight")
    }
    
    // MARK: - Logic
    func answeredCorrectly()
    {
        weight /= 2
    }
    
    func answeredIncorrectly()
    {
        weight *= 2
    }
    
    func isMastered() -> Bool
    {
        return weight <= 64
    }
}