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
    
    @IBOutlet weak var civicsView: UIView!
    @IBOutlet weak var readingView: UIView!
    @IBOutlet weak var writingView: UIView!
    
    // MARK: - View Controller
    override func viewDidLoad()
    {
        // cancel out gray for storyboard
        // TODO: once this is solid, just set to gray in StoryBoard
        civicsView.layer.backgroundColor = UIColor.clearColor().CGColor
        readingView.layer.backgroundColor = UIColor.clearColor().CGColor
        writingView.layer.backgroundColor = UIColor.clearColor().CGColor
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // Not learning anything right now, so no learning mode.
        currentLearningMode = nil
        
        makeGraphForView(civicsView, andQuestionBank: dataModel.civicsQuestionBank)
        makeGraphForView(readingView, andQuestionBank: dataModel.civicsQuestionBank)
        makeGraphForView(writingView, andQuestionBank: dataModel.civicsQuestionBank)
        
        // animate graph
        animate()
    }
    
    func animate()
    {
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        view.layer.addAnimation(transition, forKey: nil)
    }
    
    // Creates the circular pie graph that surrounds each button (civics, reading, writing)
    func makeGraphForView(aView: UIView!, andQuestionBank aQuestionBank: CivicsQuestionBank!)
    {
        // make incorrect piece
        let incorrectPiece = makePiePieceForView(aView, forAccuracy: aQuestionBank.percentMastered(), andIsCorrect: false)
        aView.layer.addSublayer(incorrectPiece)
        
        // make correct piece
        let correctPiece = makePiePieceForView(aView, forAccuracy: aQuestionBank.percentMastered(), andIsCorrect: true)
        aView.layer.addSublayer(correctPiece)
    }
    
    func makePiePieceForView(view: UIView, forAccuracy accuracy: Float, andIsCorrect isCorrect: Bool) -> CAShapeLayer
    {
        // Make shape.
        var piePiece = CAShapeLayer()
        piePiece.fillColor = UIColor.clearColor().CGColor
        piePiece.strokeColor = isCorrect ? UIColor.greenColor().CGColor : UIColor.redColor().CGColor
        piePiece.lineWidth = view.bounds.width / 20
        
        // Get properties of circle.
        let center = CGPointMake(view.bounds.width/2, view.bounds.width/2)
        let radius = view.bounds.width/2 - piePiece.lineWidth/2.0
        
        // Start at 12 o'clock.
        let startingAngle = (-90).degreesToRadians
        let startingPoint = CGPointMake(center.x + CGFloat(radius) * CGFloat(cosf(startingAngle)), center.y + CGFloat(radius) * CGFloat(sinf(startingAngle)))
        let piePath = UIBezierPath()
        piePath.moveToPoint(startingPoint)
        
        // If correct, move counterclockwise, else move clockwise.
        // Distance moved is based upon percent of questions mastered.
        let radiansToShow = ((360.0 * (isCorrect ? accuracy : 1.0 - accuracy))).degreesToRadians
        let endingAngle = isCorrect ? startingAngle - radiansToShow : startingAngle + radiansToShow
        let endingPoint = CGPointMake(center.x + CGFloat(radius) * CGFloat(cosf(endingAngle)), center.y + CGFloat(radius) * CGFloat(sinf(endingAngle)))
        let isClockwise = !isCorrect
        piePath.addArcWithCenter(center, radius: CGFloat(radius), startAngle: CGFloat(startingAngle), endAngle: CGFloat(endingAngle), clockwise: isClockwise)
        
        // Add path to shape.
        piePiece.path = piePath.CGPath
        
        return piePiece
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowCivics"
        {
            currentLearningMode = .Civics
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! CivicsViewController
            controller.dataModel = dataModel // TODO: as design firms up, only pass question bank, keeping VC as dumb as possible
            controller.openEarsEngine = openEarsEngine
        }
        else if segue.identifier == "ShowReading"
        {
            currentLearningMode = .Reading
            
            // TODO:
        }
        else if segue.identifier == "ShowWriting"
        {
            currentLearningMode = .Writing
            
            // TODO:
        }
    }

}

extension Float {
    var degreesToRadians : Float {
        return Float(self) * Float(M_PI) / 180.0
    }
}

extension Int {
    var degreesToRadians : Float {
        return Float(self) * Float(M_PI) / 180.0
    }
}
