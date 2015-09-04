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
    var vocabularyList = [ReadingWord]()
    
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
        vocabularyList = aDecoder.decodeObjectForKey(kVocabularyList) as! [ReadingWord]
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
            
            for wordString in sentenceWords
            {
                var readingWord = readingWordForText(wordString)
                if !readingWord.isMastered()
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
    
    // Given a word string, return the ReadingWord object with that word string
    func readingWordForText(text: String) -> ReadingWord
    {
        var readingWord = ReadingWord(text: "")
        
        for vocabulary in vocabularyList
        {
            if vocabulary.text == text
            {
                readingWord = vocabulary
                break
            }
        }
        
        return readingWord
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
            var readingWord = readingWordForText(word)
            
            if promptSet.contains(readingWord.text)
            {
                readingWord.answeredCorrectly()
            }
            else
            {
                readingWord.answeredIncorrectly()
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
        vocabularyList.append(ReadingWord(text: "ABRAHAM LINCOLN"))
        vocabularyList.append(ReadingWord(text: "GEORGE WASHINGTON"))
        vocabularyList.append(ReadingWord(text: "AMERICAN FLAG"))
        vocabularyList.append(ReadingWord(text: "BILL OF RIGHTS"))
        vocabularyList.append(ReadingWord(text: "CAPITAL"))
        vocabularyList.append(ReadingWord(text: "CITIZEN"))
        vocabularyList.append(ReadingWord(text: "CITY"))
        vocabularyList.append(ReadingWord(text: "CONGRESS"))
        vocabularyList.append(ReadingWord(text: "COUNTRY"))
        vocabularyList.append(ReadingWord(text: "FATHER OF OUR COUNTRY"))
        vocabularyList.append(ReadingWord(text: "GOVERNMENT"))
        vocabularyList.append(ReadingWord(text: "PRESIDENT"))
        vocabularyList.append(ReadingWord(text: "RIGHT"))
        vocabularyList.append(ReadingWord(text: "SENATORS"))
        vocabularyList.append(ReadingWord(text: "STATE"))
        vocabularyList.append(ReadingWord(text: "STATES"))
        vocabularyList.append(ReadingWord(text: "WHITE HOUSE"))
        vocabularyList.append(ReadingWord(text: "AMERICA"))
        vocabularyList.append(ReadingWord(text: "UNITED STATES"))
        vocabularyList.append(ReadingWord(text: "U.S.")) // TODO: test this. OE might give you trouble.
        vocabularyList.append(ReadingWord(text: "PRESIDENTS' DAY"))
        vocabularyList.append(ReadingWord(text: "MEMORIAL DAY"))
        vocabularyList.append(ReadingWord(text: "FLAG DAY"))
        vocabularyList.append(ReadingWord(text: "INDEPENDENCE DAY"))
        vocabularyList.append(ReadingWord(text: "LABOR DAY"))
        vocabularyList.append(ReadingWord(text: "COLUMBUS DAY"))
        vocabularyList.append(ReadingWord(text: "THANKSGIVING"))
        vocabularyList.append(ReadingWord(text: "HOW"))
        vocabularyList.append(ReadingWord(text: "WHAT"))
        vocabularyList.append(ReadingWord(text: "WHEN"))
        vocabularyList.append(ReadingWord(text: "WHERE"))
        vocabularyList.append(ReadingWord(text: "WHO"))
        vocabularyList.append(ReadingWord(text: "WHY"))
        vocabularyList.append(ReadingWord(text: "CAN"))
        vocabularyList.append(ReadingWord(text: "COME"))
        vocabularyList.append(ReadingWord(text: "DO"))
        vocabularyList.append(ReadingWord(text: "DOES"))
        vocabularyList.append(ReadingWord(text: "ELECTS"))
        vocabularyList.append(ReadingWord(text: "HAVE"))
        vocabularyList.append(ReadingWord(text: "HAS"))
        vocabularyList.append(ReadingWord(text: "IS"))
        vocabularyList.append(ReadingWord(text: "ARE"))
        vocabularyList.append(ReadingWord(text: "WAS"))
        vocabularyList.append(ReadingWord(text: "BE"))
        vocabularyList.append(ReadingWord(text: "LIVES"))
        vocabularyList.append(ReadingWord(text: "LIVED"))
        vocabularyList.append(ReadingWord(text: "MEET"))
        vocabularyList.append(ReadingWord(text: "NAME"))
        vocabularyList.append(ReadingWord(text: "PAY"))
        vocabularyList.append(ReadingWord(text: "VOTE"))
        vocabularyList.append(ReadingWord(text: "WANT"))
        vocabularyList.append(ReadingWord(text: "A"))
        vocabularyList.append(ReadingWord(text: "FOR"))
        vocabularyList.append(ReadingWord(text: "HERE"))
        vocabularyList.append(ReadingWord(text: "IN"))
        vocabularyList.append(ReadingWord(text: "OF"))
        vocabularyList.append(ReadingWord(text: "ON"))
        vocabularyList.append(ReadingWord(text: "THE"))
        vocabularyList.append(ReadingWord(text: "TO"))
        vocabularyList.append(ReadingWord(text: "WE"))
        vocabularyList.append(ReadingWord(text: "COLORS"))
        vocabularyList.append(ReadingWord(text: "DOLLAR BILL"))
        vocabularyList.append(ReadingWord(text: "FIRST"))
        vocabularyList.append(ReadingWord(text: "LARGEST"))
        vocabularyList.append(ReadingWord(text: "MANY"))
        vocabularyList.append(ReadingWord(text: "MOST"))
        vocabularyList.append(ReadingWord(text: "NORTH"))
        vocabularyList.append(ReadingWord(text: "ONE"))
        vocabularyList.append(ReadingWord(text: "PEOPLE"))
        vocabularyList.append(ReadingWord(text: "SECOND"))
        vocabularyList.append(ReadingWord(text: "SOUTH"))
    }
    
    // MARK: - Debugging
    func printSentenceWordCounts()
    {
        // TODO:
    }
}