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
    
    @IBOutlet weak var civicsRedCircle: UIView!
    
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
        CAShapeLayer *slice = [CAShapeLayer layer];
        slice.fillColor = [UIColor redColor].CGColor;
        slice.strokeColor = [UIColor blackColor].CGColor;
        slice.lineWidth = 3.0;
        
        CGFloat angle = DEG2RAD(-60.0);
        CGPoint center = CGPointMake(100.0, 100.0);
        CGFloat radius = 100.0;
        
        UIBezierPath *piePath = [UIBezierPath bezierPath];
        [piePath moveToPoint:center];
        
        [piePath addLineToPoint:CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle))];
        
        [piePath addArcWithCenter:center radius:radius startAngle:angle endAngle:DEG2RAD(60.0) clockwise:YES];
        
        //  [piePath addLineToPoint:center];
        [piePath closePath]; // this will automatically add a straight line to the center
        slice.path = piePath.CGPath;


*/
        
        
        
        
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
        
        // make full red
        let l1 = CALayer()
        l1.frame = civicsRedCircle.bounds
        l1.borderColor = UIColor.redColor().CGColor
        l1.backgroundColor = UIColor.clearColor().CGColor
        l1.borderWidth = 10.0
        l1.cornerRadius = l1.frame.width/2
        
        civicsRedCircle.layer.addSublayer(l1)
        
        // make slice
        let slice = CAShapeLayer()
        slice.fillColor = UIColor.clearColor().CGColor
        slice.strokeColor = UIColor.greenColor().CGColor
        slice.lineWidth = 10.0
        
        let angle = -90.degreesToRadians
        let center = CGPointMake(civicsRedCircle.frame.width/2, civicsRedCircle.frame.width/2)
        let radius = civicsRedCircle.bounds.width/2 - 5.0
        let piePath = UIBezierPath()
        
        piePath.moveToPoint(CGPointMake(center.x + CGFloat(radius) * CGFloat(cosf(angle)), center.y + CGFloat(radius) * CGFloat(sinf(angle))))
        
        piePath.addArcWithCenter(center, radius: CGFloat(radius), startAngle: CGFloat(angle), endAngle: CGFloat(60.degreesToRadians), clockwise: true)
        
        slice.path = piePath.CGPath
        
        civicsRedCircle.layer.addSublayer(slice)
        
        
        
        
    }
    
    
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ShowCivicsPractice"
        {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! CivicsPracticeViewController
            controller.dataModel = dataModel // TODO: as design firms up, only pass question bank, keeping VC as dumb as possible
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

extension Int {
    var degreesToRadians : Float {
        return Float(self) * Float(M_PI) / 180.0
    }
}
