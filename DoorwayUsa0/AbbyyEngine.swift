//
//  AbbyyEngine.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/6/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

protocol AbbyyEngineDelegate: class
{
    
}

class AbbyyEngine: NSObject
{
    weak var delegate: AbbyyEngineDelegate?
    
    var applicationId: String!
    var applicationPassword: String!
    
    override init()
    {
        super.init()
        
        applicationId = ABBYY_APPLICATION_ID
        applicationPassword = ABBYY_APPLICATION_PASSWORD
    }
    
    func processImage(takenPicture: UIImage?)
    {
        if let image = takenPicture
        {
            sendPhoto(takenPicture as UIImage!)
        }
    }
    
    func sendPhoto(photoToSend: UIImage)
    {
        
    }
    
    func receiveResponse()
    {
        
    }
    
    func stopEngine()
    {
        // TODO:
    }
}