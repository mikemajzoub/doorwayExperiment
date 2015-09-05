//
//  WritingViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/4/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class WritingViewController: UIViewController, OpenEarsEngineDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var dataModel: DataModel!
    var openEarsEngine: OpenEarsEngine!
    
    var currentQuestion: String!
    
    var questionCycleIsFinishing = true
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        openEarsEngine.delegate = self
        
        /////////////////////////////////////////////////////// beginPractice()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        openEarsEngine.stopEngine()
    }
    
    func beginPractice()
    {
        askQuestion()
    }
    
    // Grab next question, speak it, and begin listening for user's answer
    func askQuestion()
    {
        questionCycleIsFinishing = false
        
        dataModel.writingQuestionBank.refreshActiveBoundaryIndex()
        
        if let question = dataModel.readingQuestionBank?.nextQuestion()
        {
            
            currentQuestion = question
            
            var sayThis = "Please write the following sentence on a sheet of paper, and then take a picture of it." + question
            
            openEarsEngine.say(sayThis)
            
        }
    }
    
    // MARK: - TakePicture
    @IBAction func takePicture()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
        {
            dismissViewControllerAnimated(true, completion: nil) }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ABBYYDelegate
    
    // TODO:
    
    // MARK: - OpenEarsEngineDelegate
    
    func computerFinishedSpeaking()
    {
        if questionCycleIsFinishing
        {
            askQuestion()
        }
    }
    
    func computerPausedListening()
    {
        
    }
    
    func computerResumedListening()
    {
        
    }
    
    func heardWords(words: String!, withRecognitionScore recognitionScore: String!)
    {
        // NOT RELEVANT FOR WRITING
    }
}