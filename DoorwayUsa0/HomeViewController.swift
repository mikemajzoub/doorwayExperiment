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
        
        // This makes the animation go.
        view.layer.addAnimation(transition, forKey: nil)
    }
    
    func makeGraphForView(aView: UIView!, andQuestionBank aQuestionBank: CivicsQuestionBank!)
    {
        
        
        println("aQuestionBank: \(aQuestionBank)")
        
        // make incorrect piece
        let incorrectPiece = makePiePieceForView(aView, forAccuracy: aQuestionBank.percentMastered(), andIsCorrect: false)
        aView.layer.addSublayer(incorrectPiece)
        
        // make correct piece
        let correctPiece = makePiePieceForView(aView, forAccuracy: aQuestionBank.percentMastered(), andIsCorrect: true)
        aView.layer.addSublayer(correctPiece)
        
        // animate pie graph entrance to UI
        
    }
    
    func makePiePieceForView(view: UIView, forAccuracy accuracy: Float, andIsCorrect isCorrect: Bool) -> CAShapeLayer
    {
        var piePiece = CAShapeLayer()
        piePiece.fillColor = UIColor.clearColor().CGColor
        piePiece.strokeColor = isCorrect ? UIColor.greenColor().CGColor : UIColor.redColor().CGColor
        piePiece.lineWidth = view.bounds.width / 50
        
        let center = CGPointMake(view.bounds.width/2, view.bounds.width/2)
        let radius = view.bounds.width/2 - piePiece.lineWidth/2.0
        
        let startingAngle = (-90).degreesToRadians
        let startingPoint = CGPointMake(center.x + CGFloat(radius) * CGFloat(cosf(startingAngle)), center.y + CGFloat(radius) * CGFloat(sinf(startingAngle)))
        
        let radiansToShow = ((360.0 * (isCorrect ? accuracy : 1.0 - accuracy))).degreesToRadians
        let endingAngle = isCorrect ? startingAngle - radiansToShow : startingAngle + radiansToShow
        let endingPoint = CGPointMake(center.x + CGFloat(radius) * CGFloat(cosf(endingAngle)), center.y + CGFloat(radius) * CGFloat(sinf(endingAngle)))
        
        let piePath = UIBezierPath()
        piePath.moveToPoint(startingPoint)
        
        let isClockwise = !isCorrect
        piePath.addArcWithCenter(center, radius: CGFloat(radius), startAngle: CGFloat(startingAngle), endAngle: CGFloat(endingAngle), clockwise: isClockwise)
        
        piePiece.path = piePath.CGPath
        
        return piePiece
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowCivics"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! CivicsPracticeViewController
            controller.dataModel = dataModel // TODO: as design firms up, only pass question bank, keeping VC as dumb as possible
            controller.openEarsEngine = openEarsEngine
        }
        else if segue.identifier == "ShowReading"
        {
            // TODO:
        }
        else if segue.identifier == "ShowWriting"
        {
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
