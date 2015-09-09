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
    var vocabularyList = [VocabularyTerm]()
    
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
        let responseArray = response.componentsSeparatedByString(" ")
        let promptArray: NSArray = prompt.componentsSeparatedByString(" ")
        let promptMutableArray = promptArray.mutableCopy() as! NSMutableArray
        
        // mark correctly answered words, removing them from prompt
        for word in responseArray
        {
            if promptMutableArray.indexOfObject(word) != NSNotFound
            {
                var vocabularyTerm = vocabularyTermForText(word)
                vocabularyTerm.answeredCorrectly()
                
                let indexOfTerm = promptMutableArray.indexOfObject(word)
                promptMutableArray.removeObjectAtIndex(indexOfTerm)
            }
        }
        
        // whatever remains in prompt at this time was not correctly answered
        let notAnswered = promptMutableArray.copy() as! [String]
        for word in notAnswered
        {
            let vocabularyTerm = vocabularyTermForText(word)
            vocabularyTerm.answeredIncorrectly()
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
        vocabularyList.append(VocabularyTerm(text: "ABRAHAM LINCOLN"))
        vocabularyList.append(VocabularyTerm(text: "GEORGE WASHINGTON"))
        vocabularyList.append(VocabularyTerm(text: "AMERICAN FLAG"))
        vocabularyList.append(VocabularyTerm(text: "BILL OF RIGHTS"))
        vocabularyList.append(VocabularyTerm(text: "CAPITAL"))
        vocabularyList.append(VocabularyTerm(text: "CITIZEN"))
        vocabularyList.append(VocabularyTerm(text: "CITY"))
        vocabularyList.append(VocabularyTerm(text: "CONGRESS"))
        vocabularyList.append(VocabularyTerm(text: "COUNTRY"))
        vocabularyList.append(VocabularyTerm(text: "FATHER OF OUR COUNTRY"))
        vocabularyList.append(VocabularyTerm(text: "GOVERNMENT"))
        vocabularyList.append(VocabularyTerm(text: "PRESIDENT"))
        vocabularyList.append(VocabularyTerm(text: "RIGHT"))
        vocabularyList.append(VocabularyTerm(text: "SENATORS"))
        vocabularyList.append(VocabularyTerm(text: "STATE"))
        vocabularyList.append(VocabularyTerm(text: "STATES"))
        vocabularyList.append(VocabularyTerm(text: "WHITE HOUSE"))
        vocabularyList.append(VocabularyTerm(text: "AMERICA"))
        vocabularyList.append(VocabularyTerm(text: "UNITED STATES"))
        vocabularyList.append(VocabularyTerm(text: "U.S.")) // TODO: test this. OE might give you trouble.
        vocabularyList.append(VocabularyTerm(text: "PRESIDENTS' DAY"))
        vocabularyList.append(VocabularyTerm(text: "MEMORIAL DAY"))
        vocabularyList.append(VocabularyTerm(text: "FLAG DAY"))
        vocabularyList.append(VocabularyTerm(text: "INDEPENDENCE DAY"))
        vocabularyList.append(VocabularyTerm(text: "LABOR DAY"))
        vocabularyList.append(VocabularyTerm(text: "COLUMBUS DAY"))
        vocabularyList.append(VocabularyTerm(text: "THANKSGIVING"))
        vocabularyList.append(VocabularyTerm(text: "HOW"))
        vocabularyList.append(VocabularyTerm(text: "WHAT"))
        vocabularyList.append(VocabularyTerm(text: "WHEN"))
        vocabularyList.append(VocabularyTerm(text: "WHERE"))
        vocabularyList.append(VocabularyTerm(text: "WHO"))
        vocabularyList.append(VocabularyTerm(text: "WHY"))
        vocabularyList.append(VocabularyTerm(text: "CAN"))
        vocabularyList.append(VocabularyTerm(text: "COME"))
        vocabularyList.append(VocabularyTerm(text: "DO"))
        vocabularyList.append(VocabularyTerm(text: "DOES"))
        vocabularyList.append(VocabularyTerm(text: "ELECTS"))
        vocabularyList.append(VocabularyTerm(text: "HAVE"))
        vocabularyList.append(VocabularyTerm(text: "HAS"))
        vocabularyList.append(VocabularyTerm(text: "IS"))
        vocabularyList.append(VocabularyTerm(text: "ARE"))
        vocabularyList.append(VocabularyTerm(text: "WAS"))
        vocabularyList.append(VocabularyTerm(text: "BE"))
        vocabularyList.append(VocabularyTerm(text: "LIVES"))
        vocabularyList.append(VocabularyTerm(text: "LIVED"))
        vocabularyList.append(VocabularyTerm(text: "MEET"))
        vocabularyList.append(VocabularyTerm(text: "NAME"))
        vocabularyList.append(VocabularyTerm(text: "PAY"))
        vocabularyList.append(VocabularyTerm(text: "VOTE"))
        vocabularyList.append(VocabularyTerm(text: "WANT"))
        vocabularyList.append(VocabularyTerm(text: "A"))
        vocabularyList.append(VocabularyTerm(text: "FOR"))
        vocabularyList.append(VocabularyTerm(text: "HERE"))
        vocabularyList.append(VocabularyTerm(text: "IN"))
        vocabularyList.append(VocabularyTerm(text: "OF"))
        vocabularyList.append(VocabularyTerm(text: "ON"))
        vocabularyList.append(VocabularyTerm(text: "THE"))
        vocabularyList.append(VocabularyTerm(text: "TO"))
        vocabularyList.append(VocabularyTerm(text: "WE"))
        vocabularyList.append(VocabularyTerm(text: "COLORS"))
        vocabularyList.append(VocabularyTerm(text: "DOLLAR BILL"))
        vocabularyList.append(VocabularyTerm(text: "FIRST"))
        vocabularyList.append(VocabularyTerm(text: "LARGEST"))
        vocabularyList.append(VocabularyTerm(text: "MANY"))
        vocabularyList.append(VocabularyTerm(text: "MOST"))
        vocabularyList.append(VocabularyTerm(text: "NORTH"))
        vocabularyList.append(VocabularyTerm(text: "ONE"))
        vocabularyList.append(VocabularyTerm(text: "PEOPLE"))
        vocabularyList.append(VocabularyTerm(text: "SECOND"))
        vocabularyList.append(VocabularyTerm(text: "SOUTH"))
    }
    
    // MARK: - Debugging
    func printSentenceWordCounts()
    {
        // TODO:
    }
}