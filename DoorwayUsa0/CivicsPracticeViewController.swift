//
//  CivicsPracticeViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/29/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class CivicsPracticeViewController: UIViewController, OpenEarsEngineDelegate
{
    var dataModel: DataModel!
    var openEarsEngine: OpenEarsEngine!
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        beginPractice()
    }
    
    func beginPractice()
    {
        // ask question
        askQuestion()
        
        // listen for answer
        
        // receive answer
        
        // if correct, say, "correct, ANSWER"
        
        // if incorrect, say, "incorrect. the correct answer was ANSWER1 or ANSWER2 or ANSWER3"
        
        // ask question
    }
    
    func askQuestion()
    {
        if let question = dataModel.civicsQuestionBank.nextQuestion()
        {
            openEarsEngine.say(question.question)
            openEarsEngine.startListening()
        }
    }
}