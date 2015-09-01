//
//  DataModel.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/31/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

class DataModel
{
    var civicsQuestionBank = CivicsQuestionBank()
    // var readingQuestionBank
    // var writingQuestionBank
    
    // Save/Load Banks
    func saveQuestionBanks()
    {
        // Civics
        let civicsData = NSMutableData()
        let civicsArchiver = NSKeyedArchiver(forWritingWithMutableData: civicsData)
        civicsArchiver.encodeObject(civicsQuestionBank, forKey: civicsQuestionBank.name)
        civicsArchiver.finishEncoding()
        civicsData.writeToFile(dataFilePath(civicsQuestionBank.name), atomically: true)
        
        // Reading
        
        // Writing
    }
    
    func loadQuestionBanks()
    {
        // Civics
        let civicsPath = dataFilePath(civicsQuestionBank.name)
        if NSFileManager.defaultManager().fileExistsAtPath(civicsPath) {
            if let data = NSData(contentsOfFile: civicsPath)
            {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                civicsQuestionBank = unarchiver.decodeObjectForKey(civicsQuestionBank.name) as! CivicsQuestionBank
                unarchiver.finishDecoding()
            }
        }
        
        // Reading
        
        // Writing
    }
    
    
    
    // MARK: - Helper
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
    
    func dataFilePath(name: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(name + ".plist")
    }
}
