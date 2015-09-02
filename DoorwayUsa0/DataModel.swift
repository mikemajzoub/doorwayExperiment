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
    var civicsQuestionBank: CivicsQuestionBank!
    // var readingQuestionBank
    // var writingQuestionBank
    
    // MARK: - Init
    init()
    {
        loadQuestionBanks()
        registerDefaults()
        handleFirstTime()
    }
    
    func registerDefaults()
    {
        let dictionary = [ "FirstTime": true ]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func handleFirstTime()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime
        {
            civicsQuestionBank = CivicsQuestionBank()
            civicsQuestionBank.initializeQuestions()

            userDefaults.setBool(false, forKey: "FirstTime")
        }
    }
    
    // MARK: - Save/Load Banks
    func saveQuestionBanks()
    {
        // Civics
        let civicsData = NSMutableData()
        let civicsArchiver = NSKeyedArchiver(forWritingWithMutableData: civicsData)
        civicsArchiver.encodeObject(civicsQuestionBank, forKey: "CivicsQuestionBank")
        civicsArchiver.finishEncoding()
        civicsData.writeToFile(dataFilePath("CivicsQuestionBank"), atomically: true)
        
        // Reading
        
        // Writing
    }
    
    func loadQuestionBanks()
    {
        // Civics
        let civicsPath = dataFilePath("CivicsQuestionBank")
        if NSFileManager.defaultManager().fileExistsAtPath(civicsPath) {
            if let data = NSData(contentsOfFile: civicsPath)
            {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                civicsQuestionBank = unarchiver.decodeObjectForKey("CivicsQuestionBank") as! CivicsQuestionBank
                unarchiver.finishDecoding()
            }
        }
        
        // Reading
        
        // Writing
    }
    
    
    
    // MARK: - Helper
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        
        println(paths[0])
        
        return paths[0]
    }
    
    func dataFilePath(name: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(name + ".plist")
    }
}
