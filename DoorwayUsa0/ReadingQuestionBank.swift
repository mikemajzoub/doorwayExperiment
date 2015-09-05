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
    let kVocabularyList = "VocabularyListName"
    let kSentences = "SentencesName"
    let kActiveBoundaryIndex = "ActiveBoundaryIndexName"
    
    // This holds the vocab list the student must master
    var vocabularyList = [ReadingVocabulary]()
    
    // This holds sentences made up of the vocab list. The student practices
    // with these sentences, instead of just reading random words.
    var sentences = [String]()
    
    // The activeBoundaryIndex is what keeps the user from being overwhelmed with too
    // many new sentences at once. It starts by only quizzing user on X sentences,
    // and once the user has mastered these, it will quiz user on X + Y sentences.
    // It will continue this pattern of increasing the sentences can be randomly
    // selected until the entire sentence bank is revealed to the user.
    var activeBoundaryIndex = 3
    
    // MARK: - Init
    override init()
    {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        vocabularyList = aDecoder.decodeObjectForKey(kVocabularyList) as! [ReadingVocabulary]
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
            let sentenceWords = Set(sentence.componentsSeparatedByString(" "))
            
            for vocabularyString in sentenceWords
            {
                var readingVocabulary = readingVocabularyForText(vocabularyString)
                if !readingVocabulary.isMastered()
                {
                    allMastered = false
                    
                    break
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
    
    // Given a word string, return the ReadingVocabulary object with that word string
    func readingVocabularyForText(text: String) -> ReadingVocabulary
    {
        var readingVocabulary = ReadingVocabulary(text: "")
        
        for vocabulary in vocabularyList
        {
            if vocabulary.text == text
            {
                readingVocabulary = vocabulary
                break
            }
        }
        
        return readingVocabulary
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
        var language = [String]()
        
        // Make language model with sentences instead of just the vocab list
        // stored in 'words' array, because this will increase probability of
        // recognizing a correct answer
        for sentence in sentences
        {
            language.append(sentence)
        }
        
        return language
    }
    
    // Mark spoken words as correct/incorrect, updating their weights accordingly
    func updateWordsForSpokenResponse(response: String, forSentencePrompt prompt: String)
    {
        // TODO: this really should be a dictionary to handle multiple cases of same word, removing word after it's used
        let responseSet = Set(response.componentsSeparatedByString(" "))
        let promptSet = Set(response.componentsSeparatedByString(" "))
        
        for word in responseSet
        {
            var readingVocabulary = readingVocabularyForText(word)
            
            if promptSet.contains(readingVocabulary.text)
            {
                readingVocabulary.answeredCorrectly()
            }
            else
            {
                readingVocabulary.answeredIncorrectly()
            }
        }
    }
    
    // MARK: - Initialize Data
    
    // There is nothing special about these sentences, aside from them being made up entirely of words from the vocab list.
    func initializeSentences()
    {
        sentences.append("ABRAHAM LINCOLN LIVED IN THE WHITE HOUSE")
        sentences.append("GEORGE WASHINGTON WAS THE FATHER OF OUR COUNTRY")
        sentences.append("MEMORIAL DAY IS A DAY")
        sentences.append("THE U.S. HAS A GOVERNMENT")
    }
    
    // This is the vocab list that the student must master
    func initializeVocabularyList()
    {
        vocabularyList.append(ReadingVocabulary(text: "ABRAHAM LINCOLN"))
        vocabularyList.append(ReadingVocabulary(text: "GEORGE WASHINGTON"))
        vocabularyList.append(ReadingVocabulary(text: "AMERICAN FLAG"))
        vocabularyList.append(ReadingVocabulary(text: "BILL OF RIGHTS"))
        vocabularyList.append(ReadingVocabulary(text: "CAPITAL"))
        vocabularyList.append(ReadingVocabulary(text: "CITIZEN"))
        vocabularyList.append(ReadingVocabulary(text: "CITY"))
        vocabularyList.append(ReadingVocabulary(text: "CONGRESS"))
        vocabularyList.append(ReadingVocabulary(text: "COUNTRY"))
        vocabularyList.append(ReadingVocabulary(text: "FATHER OF OUR COUNTRY"))
        vocabularyList.append(ReadingVocabulary(text: "GOVERNMENT"))
        vocabularyList.append(ReadingVocabulary(text: "PRESIDENT"))
        vocabularyList.append(ReadingVocabulary(text: "RIGHT"))
        vocabularyList.append(ReadingVocabulary(text: "SENATORS"))
        vocabularyList.append(ReadingVocabulary(text: "STATE"))
        vocabularyList.append(ReadingVocabulary(text: "STATES"))
        vocabularyList.append(ReadingVocabulary(text: "WHITE HOUSE"))
        vocabularyList.append(ReadingVocabulary(text: "AMERICA"))
        vocabularyList.append(ReadingVocabulary(text: "UNITED STATES"))
        vocabularyList.append(ReadingVocabulary(text: "U.S.")) // TODO: test this. OE might give you trouble.
        vocabularyList.append(ReadingVocabulary(text: "PRESIDENTS' DAY"))
        vocabularyList.append(ReadingVocabulary(text: "MEMORIAL DAY"))
        vocabularyList.append(ReadingVocabulary(text: "FLAG DAY"))
        vocabularyList.append(ReadingVocabulary(text: "INDEPENDENCE DAY"))
        vocabularyList.append(ReadingVocabulary(text: "LABOR DAY"))
        vocabularyList.append(ReadingVocabulary(text: "COLUMBUS DAY"))
        vocabularyList.append(ReadingVocabulary(text: "THANKSGIVING"))
        vocabularyList.append(ReadingVocabulary(text: "HOW"))
        vocabularyList.append(ReadingVocabulary(text: "WHAT"))
        vocabularyList.append(ReadingVocabulary(text: "WHEN"))
        vocabularyList.append(ReadingVocabulary(text: "WHERE"))
        vocabularyList.append(ReadingVocabulary(text: "WHO"))
        vocabularyList.append(ReadingVocabulary(text: "WHY"))
        vocabularyList.append(ReadingVocabulary(text: "CAN"))
        vocabularyList.append(ReadingVocabulary(text: "COME"))
        vocabularyList.append(ReadingVocabulary(text: "DO"))
        vocabularyList.append(ReadingVocabulary(text: "DOES"))
        vocabularyList.append(ReadingVocabulary(text: "ELECTS"))
        vocabularyList.append(ReadingVocabulary(text: "HAVE"))
        vocabularyList.append(ReadingVocabulary(text: "HAS"))
        vocabularyList.append(ReadingVocabulary(text: "IS"))
        vocabularyList.append(ReadingVocabulary(text: "ARE"))
        vocabularyList.append(ReadingVocabulary(text: "WAS"))
        vocabularyList.append(ReadingVocabulary(text: "BE"))
        vocabularyList.append(ReadingVocabulary(text: "LIVES"))
        vocabularyList.append(ReadingVocabulary(text: "LIVED"))
        vocabularyList.append(ReadingVocabulary(text: "MEET"))
        vocabularyList.append(ReadingVocabulary(text: "NAME"))
        vocabularyList.append(ReadingVocabulary(text: "PAY"))
        vocabularyList.append(ReadingVocabulary(text: "VOTE"))
        vocabularyList.append(ReadingVocabulary(text: "WANT"))
        vocabularyList.append(ReadingVocabulary(text: "A"))
        vocabularyList.append(ReadingVocabulary(text: "FOR"))
        vocabularyList.append(ReadingVocabulary(text: "HERE"))
        vocabularyList.append(ReadingVocabulary(text: "IN"))
        vocabularyList.append(ReadingVocabulary(text: "OF"))
        vocabularyList.append(ReadingVocabulary(text: "ON"))
        vocabularyList.append(ReadingVocabulary(text: "THE"))
        vocabularyList.append(ReadingVocabulary(text: "TO"))
        vocabularyList.append(ReadingVocabulary(text: "WE"))
        vocabularyList.append(ReadingVocabulary(text: "COLORS"))
        vocabularyList.append(ReadingVocabulary(text: "DOLLAR BILL"))
        vocabularyList.append(ReadingVocabulary(text: "FIRST"))
        vocabularyList.append(ReadingVocabulary(text: "LARGEST"))
        vocabularyList.append(ReadingVocabulary(text: "MANY"))
        vocabularyList.append(ReadingVocabulary(text: "MOST"))
        vocabularyList.append(ReadingVocabulary(text: "NORTH"))
        vocabularyList.append(ReadingVocabulary(text: "ONE"))
        vocabularyList.append(ReadingVocabulary(text: "PEOPLE"))
        vocabularyList.append(ReadingVocabulary(text: "SECOND"))
        vocabularyList.append(ReadingVocabulary(text: "SOUTH"))
    }
    
    // MARK: - Debugging
    func printSentenceWordCounts()
    {
        // TODO:
    }
}