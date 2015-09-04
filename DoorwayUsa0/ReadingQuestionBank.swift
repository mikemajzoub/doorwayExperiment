//
//  ReadingQuestionBank.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/4/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

class ReadingQuestionBank: NSObject, NSCoding
{
    var words = [ReadingWord]()
    
    var sentences = [String]()
    
    var activeBoundaryIndex = 3
    
    // MARK: - Init
    override init()
    {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        words = aDecoder.decodeObjectForKey("Words") as! [ReadingWord]
        sentences = aDecoder.decodeObjectForKey("Sentences") as! [String]
        activeBoundaryIndex = aDecoder.decodeIntegerForKey("ActiveBoundaryIndex")
        
        super.init()
    }
    
    // MARK: - Save
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(words, forKey: "Words")
        aCoder.encodeObject(sentences, forKey: "Sentences")
        aCoder.encodeInteger(activeBoundaryIndex, forKey: "ActiveBoundaryIndex")
    }
    
    // MARK: - Logic
    func refreshActiveBoundaryIndex()
    {
        var allMastered = true
        
        for index in 0..<activeBoundaryIndex
        {
            var allMastered = true
            
            let sentence = sentences[index]
            let sentenceWords = Set(sentence.componentsSeparatedByString(" "))
            
            for wordString in sentenceWords
            {
                var readingWord = ReadingWord(text: "")
                for w in words
                {
                    if w.text == wordString
                    {
                        readingWord = w
                        break
                    }
                }
                
                if !readingWord.isMastered()
                {
                    allMastered = false
                    
                    break
                }
            }
            
            if allMastered
            {
                activeBoundaryIndex += 3
            }
            
            if activeBoundaryIndex > sentences.count
            {
                activeBoundaryIndex = sentences.count
            }
        }
        
        if allMastered
        {
            activeBoundaryIndex += 3
            
            if activeBoundaryIndex > sentences.count
            {
                activeBoundaryIndex = sentences.count
            }
        }
    }
    
    func nextQuestion() -> String
    {
        var maxSentence = ""
        var maxSentenceWeight = 0
        
        for sentence in sentences
        {
            let sentenceWords = Set(sentence.componentsSeparatedByString(" "))
            
            var sentenceWeight = 0
            for wordString in sentenceWords
            {
                var readingWord = ReadingWord(text: "")
                for w in words
                {
                    if w.text == wordString
                    {
                        readingWord = w
                        break
                    }
                }
                sentenceWeight += readingWord.weight
            }
            
            if sentenceWeight > maxSentenceWeight
            {
                maxSentenceWeight = sentenceWeight
                maxSentence = sentence
            }
        }
        
        return maxSentence
    }
    
    func percentMastered() -> Float
    {
        let total = words.count
        
        var totalCorrect = 0
        for word in words
        {
            if word.isMastered()
            {
                totalCorrect++
            }
        }
        
        return Float(totalCorrect) / Float(total)
    }
    
    func generateLanguage() -> [String]
    {
        var language = [String]()
        
        for word in words
        {
            language.append(word.text)
        }
        
        return language
    }
    
    // MARK: - Initialize Data
    func initializeSentences()
    {
        
    }
    
    func initializeWords()
    {
        
    }
    
}