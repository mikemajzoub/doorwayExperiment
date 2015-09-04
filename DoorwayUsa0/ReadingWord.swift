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
    var text = ""
    var weight: Int = ORIGINAL_WEIGHT
    
    // MARK: - Init
    init(text: String)
    {
        self.text = text
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        text = aDecoder.decodeObjectForKey("Text") as! String
        weight = aDecoder.decodeIntegerForKey("Weight")
        
        super.init()
    }
    
    // MARK: - Save
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeObject(weight, forKey: "Weight")
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
        return weight <= (ORIGINAL_WEIGHT / 4) // TODO: use exponental syntax
    }
}