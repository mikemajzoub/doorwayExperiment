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
    let kWords = "WordsName"
    let kSentences = "SentencesName"
    let kActiveBoundaryIndex = "ActiveBoundaryIndexName"
    
    // This holds the vocab list the student must master
    var words = [ReadingWord]()
    
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
        words = aDecoder.decodeObjectForKey(kWords) as! [ReadingWord]
        sentences = aDecoder.decodeObjectForKey(kSentences) as! [String]
        activeBoundaryIndex = aDecoder.decodeIntegerForKey(kActiveBoundaryIndex)
        
        super.init()
    }
    
    // MARK: - Save
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(words, forKey: kWords)
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
        
        for w in words
        {
            if w.text == text
            {
                readingWord = w
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
    
    // Iterate over vocab list, returning fraction of mastered/total words
    func percentMastered() -> Float
    {
        let total = words.count
        
        var totalMastered = 0
        for word in words
        {
            if word.isMastered()
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