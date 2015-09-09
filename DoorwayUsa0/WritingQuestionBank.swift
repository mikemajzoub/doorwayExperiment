//
//  WritingQuestionBank.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/4/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

// TODO: so much duplicated code between these question banks!! Make abstract class and subclass differences!!

class WritingQuestionBank: NSObject, NSCoding
{
    let kVocabularyList = "VocabularyListName"
    let kSentences = "SentencesName"
    let kActiveBoundaryIndex = "ActiveBoundaryIndexName"
    
    // This holds the vocab list the student must master
    var vocabularyList: [VocabularyTerm]
    
    // This holds sentences made up of the vocab list. The student practices
    // with these sentences, instead of just reading random words.
    var sentences: [String]
    
    // The activeBoundaryIndex is what keeps the user from being overwhelmed with too
    // many new sentences at once. It starts by only quizzing user on X sentences,
    // and once the user has mastered these, it will quiz user on X + Y sentences.
    // It will continue this pattern of increasing the sentences can be randomly
    // selected until the entire sentence bank is revealed to the user.
    var activeBoundaryIndex: Int
    
    // MARK: - Init
    override init()
    {
        vocabularyList = [VocabularyTerm]()
        sentences = [String]()
        activeBoundaryIndex = 3
        
        super.init()
        
        initializeSentences()
        initializeVocabularyList()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        vocabularyList = aDecoder.decodeObjectForKey(kVocabularyList) as! [VocabularyTerm]
        sentences = aDecoder.decodeObjectForKey(kSentences) as! [String]
        activeBoundaryIndex = aDecoder.decodeIntegerForKey(kActiveBoundaryIndex)
        
        super.init()
    }
    
    // MARK: - Save
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(vocabularyList, forKey: kVocabularyList)
        aCoder.encodeObject(sentences, forKey: kSentences)
        aCoder.encodeInteger(activeBoundaryIndex, forKey: kActiveBoundaryIndex)
    }
    
    // MARK: - Logic
    
    // If currently quizzed words are mastered, expand to new words via new sentences.
    func refreshActiveBoundaryIndex()
    {
        var allMastered = true
        
        for index in 0..<activeBoundaryIndex
        {
            let sentence = sentences[index]
            
            for vocabularyTerm in vocabularyList
            {
                if sentence.rangeOfString(vocabularyTerm.text) != nil
                {
                    if !vocabularyTerm.isMastered()
                    {
                        allMastered = false
                        break
                    }
                }
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
    
    // Given a word string, return the VocabularyTerm object with that word string
    func vocabularyTermForText(text: String) -> VocabularyTerm
    {
        var vocabularyTermForText = VocabularyTerm(text: "")
        
        for vocabularyTerm in vocabularyList
        {
            if vocabularyTerm.text == text
            {
                vocabularyTermForText = vocabularyTerm
                break
            }
        }
        
        if vocabularyTermForText == ""
        {
            assert(false)
        }
        
        return vocabularyTermForText
    }
    
    // Of sentences currently being quizzed, return one with greatest weight.
    func nextQuestion() -> String
    {
        var maxSentence = ""
        var maxSentenceWeight = 0
        
        for sentence in sentences
        {
            var sentenceWeight = weightForSentence(sentence)
            
            if sentenceWeight > maxSentenceWeight
            {
                maxSentenceWeight = sentenceWeight
                maxSentence = sentence
            }
        }
        
        if maxSentence == ""
        {
            assert(false)
        }
        
        return maxSentence
    }
    
    func weightForSentence(sentence: String) -> Int
    {
        var sentenceWeight = 0
        
        for vocabulary in vocabularyList
        {
            if sentence.rangeOfString(vocabulary.text) != nil
            {
                sentenceWeight += vocabulary.weight
            }
        }
        
        return sentenceWeight
    }
    
    // Iterate over vocab list, returning fraction of mastered/total words
    func percentMastered() -> Float
    {
        let total = vocabularyList.count
        
        var totalMastered = 0
        for vocabulary in vocabularyList
        {
            if vocabulary.isMastered()
            {
                totalMastered++
            }
        }
        
        return Float(totalMastered) / Float(total)
    }
    
    // Return vocab list as array
    func generateLanguage() -> [String]
    {
        return ["DUMMY_TEXT"] // empty because writing VC listens for nothing
    }
    
    // Mark spoken words as correct/incorrect, updating their weights accordingly
    func gradeResponse(responseProcessedFromPicture: String, forAnswer answer: String)
    {
        let answerArray: NSArray = answer.componentsSeparatedByString(" ")
        let incorrectWords = answerArray.mutableCopy() as! NSMutableArray
        
        for word in answerArray
        {
            let wordInAnswer = word as! String
            
            let vocabularyTerm = vocabularyTermForText(wordInAnswer)
            
            if responseProcessedFromPicture.rangeOfString(wordInAnswer) != nil
            {
                vocabularyTerm.answeredCorrectly()
            }
            else
            {
                vocabularyTerm.answeredIncorrectly()
            }
        }
    }
    
    // MARK: - Initialize Data
    
    // There is nothing special about these sentences, aside from them being made up entirely of words from the vocab list.
    func initializeSentences()
    {
        sentences.append("LINCOLN LIVED IN THE WHITE HOUSE")
        sentences.append("WASHINGTON WAS THE FATHER OF OUR COUNTRY")
        sentences.append("MEMORIAL DAY IS A DAY")
        sentences.append("ADAMS WAS A FREE PRESIDENT")
    }
    
    // This is the vocab list that the student must master
    func initializeVocabularyList()
    {
        vocabularyList.append(VocabularyTerm(text: "ADAMS"))
        vocabularyList.append(VocabularyTerm(text: "LINCOLN"))
        vocabularyList.append(VocabularyTerm(text: "WASHINGTON"))
        vocabularyList.append(VocabularyTerm(text: "AMERICAN INDIANS"))
        vocabularyList.append(VocabularyTerm(text: "CAPITAL"))
        vocabularyList.append(VocabularyTerm(text: "CITIZENS"))
        vocabularyList.append(VocabularyTerm(text: "CIVIL WAR"))
        vocabularyList.append(VocabularyTerm(text: "CONGRESS"))
        vocabularyList.append(VocabularyTerm(text: "FATHER OF OUR COUNTRY"))
        vocabularyList.append(VocabularyTerm(text: "FLAG"))
        vocabularyList.append(VocabularyTerm(text: "FREE"))
        vocabularyList.append(VocabularyTerm(text: "FREEDOM OF SPEECH"))
        vocabularyList.append(VocabularyTerm(text: "PRESIDENT"))
        vocabularyList.append(VocabularyTerm(text: "RIGHT"))
        vocabularyList.append(VocabularyTerm(text: "SENATORS"))
        vocabularyList.append(VocabularyTerm(text: "STATE"))
        vocabularyList.append(VocabularyTerm(text: "STATES"))
        vocabularyList.append(VocabularyTerm(text: "WHITE HOUSE"))
        vocabularyList.append(VocabularyTerm(text: "ALASKA"))
        vocabularyList.append(VocabularyTerm(text: "CALIFORNIA"))
        vocabularyList.append(VocabularyTerm(text: "CANADA"))
        vocabularyList.append(VocabularyTerm(text: "DELEWARE"))
        vocabularyList.append(VocabularyTerm(text: "MEXICO"))
        vocabularyList.append(VocabularyTerm(text: "NEW YORK CITY"))
        vocabularyList.append(VocabularyTerm(text: "UNITED STATES"))
        vocabularyList.append(VocabularyTerm(text: "WASHINGTON"))
        vocabularyList.append(VocabularyTerm(text: "WASHINGTON D.C."))
        vocabularyList.append(VocabularyTerm(text: "FEBRUARY"))
        vocabularyList.append(VocabularyTerm(text: "MAY"))
        vocabularyList.append(VocabularyTerm(text: "JUNE"))
        vocabularyList.append(VocabularyTerm(text: "JULY"))
        vocabularyList.append(VocabularyTerm(text: "SEPTEMBER"))
        vocabularyList.append(VocabularyTerm(text: "OCTOBER"))
        vocabularyList.append(VocabularyTerm(text: "NOVEMBER"))
        vocabularyList.append(VocabularyTerm(text: "PRESIDENTS' DAY"))
        vocabularyList.append(VocabularyTerm(text: "MEMORIAL DAY"))
        vocabularyList.append(VocabularyTerm(text: "FLAG DAY"))
        vocabularyList.append(VocabularyTerm(text: "INDEPENDENCE DAY"))
        vocabularyList.append(VocabularyTerm(text: "LABOR DAY"))
        vocabularyList.append(VocabularyTerm(text: "COLUMBUS DAY"))
        vocabularyList.append(VocabularyTerm(text: "THANKSGIVING"))
        vocabularyList.append(VocabularyTerm(text: "CAN"))
        vocabularyList.append(VocabularyTerm(text: "COME"))
        vocabularyList.append(VocabularyTerm(text: "ELECT"))
        vocabularyList.append(VocabularyTerm(text: "HAVE"))
        vocabularyList.append(VocabularyTerm(text: "HAS"))
        vocabularyList.append(VocabularyTerm(text: "IS"))
        vocabularyList.append(VocabularyTerm(text: "WAS"))
        vocabularyList.append(VocabularyTerm(text: "BE"))
        vocabularyList.append(VocabularyTerm(text: "LIVES"))
        vocabularyList.append(VocabularyTerm(text: "LIVED"))
        vocabularyList.append(VocabularyTerm(text: "MEETS"))
        vocabularyList.append(VocabularyTerm(text: "PAY"))
        vocabularyList.append(VocabularyTerm(text: "VOTE"))
        vocabularyList.append(VocabularyTerm(text: "WANT"))
        vocabularyList.append(VocabularyTerm(text: "AND"))
        vocabularyList.append(VocabularyTerm(text: "DURING"))
        vocabularyList.append(VocabularyTerm(text: "FOR"))
        vocabularyList.append(VocabularyTerm(text: "HERE"))
        vocabularyList.append(VocabularyTerm(text: "IN"))
        vocabularyList.append(VocabularyTerm(text: "OF"))
        vocabularyList.append(VocabularyTerm(text: "ON"))
        vocabularyList.append(VocabularyTerm(text: "THE"))
        vocabularyList.append(VocabularyTerm(text: "TO"))
        vocabularyList.append(VocabularyTerm(text: "WE"))
        vocabularyList.append(VocabularyTerm(text: "BLUE"))
        vocabularyList.append(VocabularyTerm(text: "DOLLAR BILL"))
        vocabularyList.append(VocabularyTerm(text: "FIFTY"))
        vocabularyList.append(VocabularyTerm(text: "50")) // ???
        vocabularyList.append(VocabularyTerm(text: "FIRST"))
        vocabularyList.append(VocabularyTerm(text: "LARGEST"))
        vocabularyList.append(VocabularyTerm(text: "MOST"))
        vocabularyList.append(VocabularyTerm(text: "NORTH"))
        vocabularyList.append(VocabularyTerm(text: "ONE"))
        vocabularyList.append(VocabularyTerm(text: "ONE HUNDRED"))
        vocabularyList.append(VocabularyTerm(text: "100")) // ???
        vocabularyList.append(VocabularyTerm(text: "PEOPLE"))
        vocabularyList.append(VocabularyTerm(text: "RED"))
        vocabularyList.append(VocabularyTerm(text: "SECOND"))
        vocabularyList.append(VocabularyTerm(text: "SOUTH"))
        vocabularyList.append(VocabularyTerm(text: "TAXES"))
        vocabularyList.append(VocabularyTerm(text: "WHITE"))
    }
    
    // MARK: - Debugging
    // TODO:
}