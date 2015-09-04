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
    let kQuestion = "QuestionName"
    let kAnswersSpoken = "AnswersSpokenName"
    let kAnswersKeywords = "AnswersKeywordsName"
    let kWeight = "WeightName"
    
    // Question to be spoken by openEars.
    let question: String
    
    // Answers to be spoken by openEars.
    let answersSpoken: [String]
    
    // Required subset of words that must be said in order for answer to be marked correct.
    let answersKeywords: [ [String] ]
    
    // Decrease weight if answered correctly, increase if answered correctly.
    // This will determine probability of question being selected in future.
    var weight: Int = ORIGINAL_WEIGHT
    
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
        question = aDecoder.decodeObjectForKey(kQuestion) as! String
        answersSpoken = aDecoder.decodeObjectForKey(kAnswersSpoken) as! [String]
        answersKeywords = aDecoder.decodeObjectForKey(kAnswersKeywords) as! [ [String] ]
        
        weight = aDecoder.decodeIntegerForKey(kWeight)
        
        super.init()
    }
    
    // MARK: - Save
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(question, forKey: kQuestion)
        aCoder.encodeObject(answersSpoken, forKey: kAnswersSpoken)
        aCoder.encodeObject(answersKeywords, forKey: kAnswersKeywords)
        
        aCoder.encodeInteger(weight, forKey: kWeight)
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
        return weight <= ((ORIGINAL_WEIGHT / 2) / 2) // TODO: use swift exponental notation
    }
}