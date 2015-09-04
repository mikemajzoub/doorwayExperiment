//
//  ReadingWord.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/4/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

class ReadingWord: NSObject
{
    let kText = "TextName"
    let kWeight = "WeightName"
    
    var text = ""
    
    // Weight influences probability of word being quizzed in future
    var weight: Int = ORIGINAL_WEIGHT
    
    // MARK: - Init
    init(text: String)
    {
        self.text = text
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        text = aDecoder.decodeObjectForKey(kText) as! String
        weight = aDecoder.decodeIntegerForKey(kWeight)
        
        super.init()
    }
    
    // MARK: - Save
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(text, forKey: kText)
        aCoder.encodeObject(weight, forKey: kWeight)
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
        return weight <= ((ORIGINAL_WEIGHT / 2) / 2) // TODO: use swift's exponental syntax
    }
}