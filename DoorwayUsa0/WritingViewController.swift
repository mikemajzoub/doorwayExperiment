//
//  WritingViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/4/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class WritingViewController: UIViewController, OpenEarsEngineDelegate, AbbyyEngineDelegate, CustomCameraControllerDelegate
{
    var dataModel: DataModel!
    var openEarsEngine: OpenEarsEngine!
    var abbyyEngine: AbbyyEngine!
    
    var currentQuestion: String!
    
    var questionCycleIsFinishing = false
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var takePictureButton: UIButton!
    
    override func viewWillAppear(animated: Bool)
    {
        openEarsEngine.delegate = self
        abbyyEngine.delegate = self
        
        setUpNextQuestion()
        
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        openEarsEngine.stopEngine()
        abbyyEngine.stopEngine()
    }
    
    // Grab next question, speak it, and begin listening for user's answer
    func setUpNextQuestion()
    {
        questionCycleIsFinishing = false
        
        actionButton.setTitle("Play Question", forState: .Normal)
        actionButton.enabled = true
        takePictureButton.enabled = false
        
        if let question = dataModel.writingQuestionBank?.nextQuestion()
        {
            currentQuestion = question
        }
    }
    
    // MARK: - Repeat sentence
    @IBAction func playSentence()
    {
        openEarsEngine.say(currentQuestion)
        
        actionButton.setTitle("Replay Question", forState: .Normal)
        takePictureButton.enabled = true
    }
    
    // MARK: - TakePicture
    @IBAction func takePicture()
    {
        let customCamera = CustomCameraController()
        customCamera.delegate = self
        
        presentViewController(customCamera.imagePicker, animated: true, completion: nil)
        
        takePictureButton.enabled = false
    }
    
    // MARK: - CustomCameraControllerDelegate
    func cameraDidCancel()
    {
        dismissViewControllerAnimated(true, completion: nil)
        
        // TODO: ???
    }
    
    func cameraDidTakePicture(picture: UIImage)
    {
        dismissViewControllerAnimated(true, completion: nil)
        
        actionButton.setTitle("Reading text...", forState: .Disabled)
        actionButton.enabled = false
        spinner.stopAnimating()
        
        abbyyEngine.processImage(picture, withAnswer: currentQuestion)
    }
    
    
    // MARK: - ABBYYDelegate
    
    func retrievedText(textFromPicture: String)
    {
        questionCycleIsFinishing = true
        
        println("processed text: \(textFromPicture)")
        
        dataModel.writingQuestionBank.gradeResponse(textFromPicture, forAnswer: currentQuestion)
        
        if dataModel.writingQuestionBank.isUserResponseCorrect(textFromPicture, forAnswer: currentQuestion)
        {
            openEarsEngine.say("Correct")
            println("Correct")
        }
        else
        {
            openEarsEngine.say("Incorrect")
            println("Incorrect")
        }
        
        spinner.stopAnimating()
    }
    
    // MARK: - OpenEarsEngineDelegate
    
    func computerFinishedSpeaking()
    {
        if questionCycleIsFinishing
        {
            setUpNextQuestion()
            actionButton.enabled = true
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