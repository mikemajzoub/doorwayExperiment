//
//  HomeViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/29/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    var dataModel: DataModel!
    var openEarsEngine: OpenEarsEngine!
    
    // MARK: - View Controller
    override func viewDidLoad()
    {
        println("hvc vdl")
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowCivicsPractice"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! CivicsPracticeViewController
            controller.dataModel = dataModel
            controller.openEarsEngine = openEarsEngine
        }
        else if segue.identifier == "ShowReadingPractice"
        {
            // TODO:
        }
        else if segue.identifier == "ShowWritingPractice"
        {
            // TODO:
        }
    }

}

