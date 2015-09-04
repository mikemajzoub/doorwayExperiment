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
    var readingQuestionBank: ReadingQuestionBank!
    // var writingQuestionBank
    
    // MARK: - Init
    init()
    {
        loadQuestionBanks()
        registerDefaults()
        handleFirstTime()
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
        let readingPath = dataFilePath("ReadingQuestionBank")
        if NSFileManager.defaultManager().fileExistsAtPath(readingPath) {
            if let data = NSData(contentsOfFile: readingPath)
            {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                readingQuestionBank = unarchiver.decodeObjectForKey("ReadingQuestionBank") as! ReadingQuestionBank
                unarchiver.finishDecoding()
            }
        }
        
        
        // Writing
    }
    
    func registerDefaults()
    {
        let dictionary = [ "FirstTime": true ]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    // If app is launching for first time, must initialize question banks.
    // After first time, question banks will be loaded from disk.
    func handleFirstTime()
    {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime
        {
            civicsQuestionBank = CivicsQuestionBank()
            civicsQuestionBank.initializeQuestions()
            
            readingQuestionBank = ReadingQuestionBank()
            readingQuestionBank.initializeSentences()
            readingQuestionBank.initializeWords()

            userDefaults.setBool(false, forKey: "FirstTime")
        }
    }
    
    // MARK: - Generate Language
    func getLanguageForLearningMode(mode: LearningMode) -> [String]
    {
        if mode == .Civics
        {
            return generateCivicsLanguage()
        }
        else // Else, mode == .Reading
        {
            return generateReadingLanguage()
        }
    }
    
    func generateCivicsLanguage() -> [String]
    {
        return civicsQuestionBank.generateLanguage()
    }
    
    func generateReadingLanguage() -> [String]
    {
        // TODO:
        return readingQuestionBank.generateLanguage()
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
        let readingData = NSMutableData()
        let readingArchiver = NSKeyedArchiver(forWritingWithMutableData: readingData)
        readingArchiver.encodeObject(readingQuestionBank, forKey: "ReadingQuestionBank")
        readingArchiver.finishEncoding()
        readingData.writeToFile(dataFilePath("ReadingQuestionBank"), atomically: true)
        
        // Writing
    }
    
    // MARK: - Directories & Paths
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        
        println(paths[0])
        
        return paths[0]
    }
    
    func dataFilePath(name: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(name + ".plist")
    }
}
