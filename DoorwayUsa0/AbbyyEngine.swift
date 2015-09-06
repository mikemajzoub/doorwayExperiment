//
//  AbbyyEngine.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/6/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

import Foundation

protocol AbbyyEngineDelegate: class
{
    
}

class AbbyyEngine: NSObject
{
    let kInstallationId = "InstallationId"
    let kActivationUrlMinusDeviceId = "http://cloud.ocrsdk.com/activateNewInstallation?deviceId="
    let kHttpHeaderField = "Authorization"
    
    weak var delegate: AbbyyEngineDelegate?
    
    var applicationId: String!
    var applicationPassword: String!
    var fullId: String!
    
    // MARK: - Init
    override init()
    {
        super.init()
        
        applicationId = ABBYY_APPLICATION_ID
        applicationPassword = ABBYY_APPLICATION_PASSWORD
        
        setUpInstallationId()
        let installationId = NSUserDefaults.standardUserDefaults().stringForKey(kInstallationId)
        fullId = "\(applicationId)\(installationId)"
    }
    
    func setUpInstallationId()
    {
        if NSUserDefaults.standardUserDefaults().stringForKey(kInstallationId) == nil
        {
            let deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
            
            let installationId = activateNewInstallationForDeviceId(deviceId)
            
            NSUserDefaults.standardUserDefaults().setValue(installationId, forKey: kInstallationId)
        }
    }
    
    func activateNewInstallationForDeviceId(deviceId: String) -> String
    {
        
        let installationId: String
        
        // set up request
        let activationUrl = NSURL(string: kActivationUrlMinusDeviceId + deviceId)
        let request = NSMutableURLRequest(URL: activationUrl!)
        let authentication = "Basic \(applicationId):\(applicationPassword)"
        request.setValue(authentication, forKey: kHttpHeaderField)
        
        var error: NSError
        
        // TODO:
        let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: 0, error: &error)
        
        // TODO:
        if error == nil
        {
            parser = NSXMLParser(data: responseData)
            parser.delegate = self
            
            // In sample code, I don't see where parser is setting installation id. look into this.
            installationId = "TODO:"
        }
        else
        {
            alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil, nil)
            alert.show()
        }
        
        return installationId
    }
    
    // MARK: - Logic
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