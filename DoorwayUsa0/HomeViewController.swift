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
    }
    
    func makeGraphForView(aView: UIView!, andQuestionBank aQuestionBank: CivicsQuestionBank!)
    {
        // cancel out gray for storyboard
        // aView.layer.backgroundColor = UIColor.clearColor().CGColor
        
        println("aQuestionBank: \(aQuestionBank)")
        
        // make red slice1
        let incorrectSlice = makePiePieceForView(aView, forAccuracy: 0.01, andIsCorrect: false)
        // let incorrectSlice = makePiePieceForView(aView, forAccuracy: aQuestionBank.percentMastered(), andIsCorrect: false)
        aView.layer.addSublayer(incorrectSlice)
        
        let correctSlice = makePiePieceForView(aView, forAccuracy: 0.01, andIsCorrect: true)
        // let correctSlice = makePiePieceForView(aView, forAccuracy: aQuestionBank.percentMastered(), andIsCorrect: true)
        aView.layer.addSublayer(correctSlice)
    }
    
    func makePiePieceForView(view: UIView, forAccuracy accuracy: Float, andIsCorrect isCorrect: Bool) -> CAShapeLayer
    {
        var piePiece = CAShapeLayer()
        piePiece.fillColor = UIColor.clearColor().CGColor
        piePiece.strokeColor = isCorrect ? UIColor.greenColor().CGColor : UIColor.redColor().CGColor
        piePiece.lineWidth = view.bounds.width / 50
        
        let center = CGPointMake(view.bounds.width/2, view.bounds.width/2)
        let radius = view.bounds.width/2 - piePiece.lineWidth/2.0
        
        let visualGap = isCorrect ? 2 : -2
        let startingAngle = (-(90 + visualGap)).degreesToRadians
        let startingPoint = CGPointMake(center.x + CGFloat(radius) * CGFloat(cosf(startingAngle)), center.y + CGFloat(radius) * CGFloat(sinf(startingAngle)))
        
        let radiansToShow = ((360.0 * (isCorrect ? accuracy : 1.0 - accuracy))  - 4.0).degreesToRadians
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
