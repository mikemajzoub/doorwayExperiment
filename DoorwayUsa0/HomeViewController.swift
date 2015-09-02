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
        
        makeCivicsPieGraph()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    func makeCivicsPieGraph()
    {
   
        
        
        
        /*
        let l1 = civicsRedCircle.layer
        l1.borderColor = UIColor.greenColor().CGColor
        l1.backgroundColor = UIColor.clearColor().CGColor
        l1.borderWidth = 10.0
        l1.cornerRadius = l1.frame.width/2
        
        let l2 = CALayer()
        l2.frame = civicsRedCircle.bounds
        l2.borderColor = UIColor.redColor().CGColor
        l2.backgroundColor = UIColor.clearColor().CGColor
        l2.borderWidth = 10.0
        l2.cornerRadius = l2.frame.width/2
        
        l1.addSublayer(l2)
        */
        
        // cancel out gray for storyboard
        civicsView.layer.backgroundColor = UIColor.clearColor().CGColor
        
        // make red slice1
        let slice1 = CAShapeLayer()
        slice1.fillColor = UIColor.clearColor().CGColor
        slice1.strokeColor = UIColor.redColor().CGColor
        slice1.lineWidth = 1.0
        
        let angle1 = (-90 - 6).degreesToRadians
        let center1 = CGPointMake(civicsView.frame.width/2, civicsView.frame.width/2)
        let radius1 = civicsView.bounds.width/2 - 16.0
        let piePath1 = UIBezierPath()
        
        piePath1.moveToPoint(CGPointMake(center1.x + CGFloat(radius1) * CGFloat(cosf(angle1)), center1.y + CGFloat(radius1) * CGFloat(sinf(angle1))))
        
        piePath1.addArcWithCenter(center1, radius: CGFloat(radius1), startAngle: CGFloat(angle1), endAngle: CGFloat((60 + 6).degreesToRadians), clockwise: false)
        
        slice1.path = piePath1.CGPath
        
        civicsView.layer.addSublayer(slice1)

        
        // make green slice2
        let slice2 = CAShapeLayer()
        slice2.fillColor = UIColor.clearColor().CGColor
        slice2.strokeColor = UIColor.greenColor().CGColor
        slice2.lineWidth = 1.0
        
        let angle = -90.degreesToRadians
        let center = CGPointMake(civicsView.frame.width/2, civicsView.frame.width/2)
        let radius = civicsView.bounds.width/2 - 16.0
        let piePath = UIBezierPath()
        
        piePath.moveToPoint(CGPointMake(center.x + CGFloat(radius) * CGFloat(cosf(angle)), center.y + CGFloat(radius) * CGFloat(sinf(angle))))
        
        piePath.addArcWithCenter(center, radius: CGFloat(radius), startAngle: CGFloat(angle), endAngle: CGFloat(60.degreesToRadians), clockwise: true)
        
        slice2.path = piePath.CGPath
        
        civicsView.layer.addSublayer(slice2)
        
        
        
        
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

extension Int {
    var degreesToRadians : Float {
        return Float(self) * Float(M_PI) / 180.0
    }
}
