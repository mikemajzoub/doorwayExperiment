//
//  HomeViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/29/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, OEEventsObserverDelegate
{
    var dataModel: DataModel!
    
    var openEarsEngine: OpenEarsEngine!
    
    
    override func viewDidLoad()
    {
        println("lala")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let question = dataModel.civicsQuestionBank.nextQuestion()
        openEarsEngine.say(question!.question)
    }
    
    

}

