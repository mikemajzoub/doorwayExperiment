//
//  CustomCameraController.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/9/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

protocol CustomCameraControllerDelegate: class
{
    func cameraDidCancel()
    func cameraDidTakePicture(picture: UIImage)
}

class CustomCameraController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var imagePicker: UIImagePickerController!
    
    var delegate: CustomCameraControllerDelegate?
    
    override init()
    {
        super.init()
        
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.allowsEditing = true
        imagePicker.showsCameraControls = true
        
        makeMask()
    }
    
    func makeMask()
    {
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
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        
        // picture is currently rotated 90 degrees counter clockwise. fixing this...
        let takenPicture = info[UIImagePickerControllerOriginalImage] as! UIImage!
        let cleanedPicture = rotateAndCropImage(takenPicture)
        
        delegate?.cameraDidTakePicture(cleanedPicture)
    }
    
    func rotateAndCropImage(dirtyImage: UIImage) -> UIImage
    {
        let t = CGAffineTransformMakeRotation(CGFloat(0))
        let currentRect = CGRect(origin: CGPointMake(0,0), size: dirtyImage.size)
        let newRect = CGRectApplyAffineTransform(currentRect, t)
        let newSize = newRect.size
        
        UIGraphicsBeginImageContext(newSize)
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, newSize.width / 2.0, newSize.height / 2.0)
        CGContextRotateCTM(context, CGFloat(0))
        dirtyImage.drawInRect(CGRectMake(-dirtyImage.size.width / 2.0, -dirtyImage.size.width / 2.0, dirtyImage.size.width, dirtyImage.size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // crop the image
        let croppedRectangle = CGRectMake(0, rotatedImage.size.height/2 + 240, rotatedImage.size.width, 340)
        let imageReference = CGImageCreateWithImageInRect(rotatedImage?.CGImage, croppedRectangle)
        let croppedImage = UIImage(CGImage: imageReference)!
        
        return croppedImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        delegate?.cameraDidCancel()
    }
}