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

class AbbyyEngine: NSObject, NSXMLParserDelegate
{
    let kInstallationId = "InstallationId"
    let kActivationUrlMinusDeviceId = "http://cloud.ocrsdk.com/activateNewInstallation?deviceId="
    
    let kHttpHeaderFieldAuthorization = "Authorization"
    
    let kProcessImageUrlMinusParameters = "http://cloud.ocrsdk.com/processImage?"
    let kProcessImageParameters = "language=English&exportFormat=txt"
    
    let kHttpMethodPost = "POST"
    
    weak var delegate: AbbyyEngineDelegate?
    
    var applicationId: String!
    var applicationPassword: String!
    var fullId: String!
    
    // XML Parser
    var isReadingAuthToken = false
    var installationId: String!
    
    // MARK: - Init
    override init()
    {
        super.init()
        
        applicationId = ABBYY_APPLICATION_ID
        applicationPassword = ABBYY_APPLICATION_PASSWORD
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
        let processingUrl = NSURL(string: (kProcessImageUrlMinusParameters + kProcessImageParameters))
        let processingRequest = NSMutableURLRequest(URL: processingUrl!)
        processingRequest.HTTPMethod = kHttpMethodPost
        processingRequest.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        processingRequest.HTTPBody = UIImageJPEGRepresentation(photoToSend as UIImage!, 0.5)
        processingRequest.setValue(authenticationString() as String, forHTTPHeaderField: kHttpHeaderFieldAuthorization)
        
        var session = NSURLSession.sharedSession()
        
        var dataTask = session.dataTaskWithRequest(processingRequest, completionHandler: { data, response, error -> Void in
            // TODO:
        })
    }
    
    func authenticationString() -> String
    {
        let authentication = "\(applicationId):\(applicationPassword)"
        let authenticationData: NSData = authentication.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Authentication = authenticationData.base64EncodedStringWithOptions(nil)
        let fullAuthenticationString = "Basic \(base64Authentication)"
        
        return fullAuthenticationString
    }
    
    func stopEngine()
    {
        // TODO:
    }
}