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
        sentences.append("ABRAHAM LINCOLN GEORGE WASHINGTON AMERICAN FLAG BILL OF RIGHTS")
        sentences.append("CAPITAL CITIZEN CITY CONGRESS COUNTRY FATHER OF OUR COUNTRY")
        sentences.append("GOVERNMENT PRESIDENT RIGHT SENATORS STATE STATES WHITE HOUSE")
        sentences.append("AMERICA UNITED STATES U.S. PRESIDENTS' DAY MEMORIAL DAY")
        sentences.append("FLAG DAY INDEPENDENCE DAY LABOR DAY COLUMBUS DAY THANKSGIVING")
        sentences.append("HOW WHAT WHEN WHERE WHO WHY CAN COME DO DOES ELECTS HAVE HAS IS ARE")
        sentences.append("WAS BE LIVES LIVED MEET NAME PAY VOTE WANT A FOR HERE IN OF ON THE TO")
        sentences.append("WE COLORS DOLLAR BILL FIRST LARGEST MANY MOST NORTH ONE PEOPLE SECOND SOUTH")
    }
    
    func initializeWords()
    {
        words.append(ReadingWord(text: "ABRAHAM LINCOLN"))
        words.append(ReadingWord(text: "GEORGE WASHINGTON"))
        words.append(ReadingWord(text: "AMERICAN FLAG"))
        words.append(ReadingWord(text: "BILL OF RIGHTS"))
        words.append(ReadingWord(text: "CAPITAL"))
        words.append(ReadingWord(text: "CITIZEN"))
        words.append(ReadingWord(text: "CITY"))
        words.append(ReadingWord(text: "CONGRESS"))
        words.append(ReadingWord(text: "COUNTRY"))
        words.append(ReadingWord(text: "FATHER OF OUR COUNTRY"))
        words.append(ReadingWord(text: "GOVERNMENT"))
        words.append(ReadingWord(text: "PRESIDENT"))
        words.append(ReadingWord(text: "RIGHT"))
        words.append(ReadingWord(text: "SENATORS"))
        words.append(ReadingWord(text: "STATE"))
        words.append(ReadingWord(text: "STATES"))
        words.append(ReadingWord(text: "WHITE HOUSE"))
        words.append(ReadingWord(text: "AMERICA"))
        words.append(ReadingWord(text: "UNITED STATES"))
        words.append(ReadingWord(text: "U.S.")) // TODO: test this. OE might give you trouble.
        words.append(ReadingWord(text: "PRESIDENTS' DAY"))
        words.append(ReadingWord(text: "MEMORIAL DAY"))
        words.append(ReadingWord(text: "FLAG DAY"))
        words.append(ReadingWord(text: "INDEPENDENCE DAY"))
        words.append(ReadingWord(text: "LABOR DAY"))
        words.append(ReadingWord(text: "COLUMBUS DAY"))
        words.append(ReadingWord(text: "THANKSGIVING"))
        words.append(ReadingWord(text: "HOW"))
        words.append(ReadingWord(text: "WHAT"))
        words.append(ReadingWord(text: "WHEN"))
        words.append(ReadingWord(text: "WHERE"))
        words.append(ReadingWord(text: "WHO"))
        words.append(ReadingWord(text: "WHY"))
        words.append(ReadingWord(text: "CAN"))
        words.append(ReadingWord(text: "COME"))
        words.append(ReadingWord(text: "DO"))
        words.append(ReadingWord(text: "DOES"))
        words.append(ReadingWord(text: "ELECTS"))
        words.append(ReadingWord(text: "HAVE"))
        words.append(ReadingWord(text: "HAS"))
        words.append(ReadingWord(text: "IS"))
        words.append(ReadingWord(text: "ARE"))
        words.append(ReadingWord(text: "WAS"))
        words.append(ReadingWord(text: "BE"))
        words.append(ReadingWord(text: "LIVES"))
        words.append(ReadingWord(text: "LIVED"))
        words.append(ReadingWord(text: "MEET"))
        words.append(ReadingWord(text: "NAME"))
        words.append(ReadingWord(text: "PAY"))
        words.append(ReadingWord(text: "VOTE"))
        words.append(ReadingWord(text: "WANT"))
        words.append(ReadingWord(text: "A"))
        words.append(ReadingWord(text: "FOR"))
        words.append(ReadingWord(text: "HERE"))
        words.append(ReadingWord(text: "IN"))
        words.append(ReadingWord(text: "OF"))
        words.append(ReadingWord(text: "ON"))
        words.append(ReadingWord(text: "THE"))
        words.append(ReadingWord(text: "TO"))
        words.append(ReadingWord(text: "WE"))
        words.append(ReadingWord(text: "COLORS"))
        words.append(ReadingWord(text: "DOLLAR BILL"))
        words.append(ReadingWord(text: "FIRST"))
        words.append(ReadingWord(text: "LARGEST"))
        words.append(ReadingWord(text: "MANY"))
        words.append(ReadingWord(text: "MOST"))
        words.append(ReadingWord(text: "NORTH"))
        words.append(ReadingWord(text: "ONE"))
        words.append(ReadingWord(text: "PEOPLE"))
        words.append(ReadingWord(text: "SECOND"))
        words.append(ReadingWord(text: "SOUTH"))
    }
    
    // MARK: - Debugging
    func printSentenceWordCounts()
    {
        // TODO:
    }
}