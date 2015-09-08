//
//  WritingViewController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/4/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import UIKit

class WritingViewController: UIViewController, OpenEarsEngineDelegate, AbbyyEngineDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var dataModel: DataModel!
    var openEarsEngine: OpenEarsEngine!
    var abbyyEngine: AbbyyEngine!
    
    var takenPicture: UIImage?
    
    var currentQuestion: String!
    
    var questionCycleIsFinishing = true
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad()
    {
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        openEarsEngine.delegate = self
        abbyyEngine.delegate = self
        
        actionButton.setTitle("Play Question", forState: .Normal)
        actionButton.enabled = true
        
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
        
        dataModel.writingQuestionBank.refreshActiveBoundaryIndex()
        
        if let question = dataModel.writingQuestionBank?.nextQuestion()
        {
            currentQuestion = question
        }
    }
    
    // MARK: - Repeat sentence
    @IBAction func playSentence()
    {
        openEarsEngine.say(currentQuestion)
    }
    
    // MARK: - TakePicture
    @IBAction func takePicture()
    {
        let imagePicker = makeCameraViewController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true ////
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func makeCameraViewController() -> UIImagePickerController
    {
        // general camera settings
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.showsCameraControls = true
        
        // make blinders
        let shiftingImagePreviewBugFix = CGFloat(31)
        let sightHeight = CGFloat(40) // DEPENDS ON PHONE?
        let cameraTopBar = CGFloat(40) + shiftingImagePreviewBugFix // DPEENDS ON PHONE!!! MUST FIX!!! (and diff for ipad!!!)
        let cameraBottomBar = CGFloat(101) - shiftingImagePreviewBugFix // DEPENDS ON PHONE!!!
        
        
        // this is to deal with the Retake/Cancel screen otherwise moving the image and making things look bad. it's hardcoded though - so must fix for each device
        imagePicker.cameraViewTransform = CGAffineTransformMakeTranslation(0, shiftingImagePreviewBugFix)
        
        let overlayView = UIView(frame: CGRectMake(0, cameraTopBar, imagePicker.view.frame.size.width, imagePicker.view.frame.size.height - cameraBottomBar - cameraTopBar))
        overlayView.backgroundColor = UIColor.clearColor()
        
        
        let blinderWidth = (overlayView.frame.size.width)
        let blinderHeight = (overlayView.frame.size.height / 2) - (sightHeight / 2)
        
        let overlayTop = UIView(frame: CGRectMake(0, 0, blinderWidth, blinderHeight))
        overlayTop.backgroundColor = UIColor.blackColor()
        overlayTop.alpha = 1.0
        overlayView.addSubview(overlayTop)
        
        let overlayBottom = UIView(frame: CGRectMake(0, blinderHeight + sightHeight, blinderWidth, blinderHeight))
        overlayBottom.backgroundColor = UIColor.blackColor()
        overlayBottom.alpha = 1.0
        overlayView.addSubview(overlayBottom)
        
        imagePicker.cameraOverlayView = overlayView
        
        return imagePicker
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        dismissViewControllerAnimated(true, completion: nil)
        
        spinner.startAnimating()
        
        var takenPicture = info[UIImagePickerControllerOriginalImage] as! UIImage?
        abbyyEngine.processImage(takenPicture, withAnswer: currentQuestion)
        
        actionButton.setTitle("Reading text...", forState: .Disabled)
        actionButton.enabled = false
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ABBYYDelegate
    
    func retrievedText(textFromPicture: String)
    {
        // TODO: split string into words, see if answer is subest of textFromPicture, allow for margin of error
        
        questionCycleIsFinishing = true
        
        println(textFromPicture)
        
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
        else
        {
            
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