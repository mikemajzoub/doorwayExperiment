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
        
        setUpInstallationId()
        
        let installationId = NSUserDefaults.standardUserDefaults().stringForKey(kInstallationId)
        fullId = "\(applicationId)\(installationId)"
    }
    
    func setUpInstallationId()
    {
        if NSUserDefaults.standardUserDefaults().stringForKey(kInstallationId) == nil
        {
            let deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
            activateNewInstallationForDeviceId(deviceId)
            NSUserDefaults.standardUserDefaults().setValue(installationId, forKey: kInstallationId)
        }
    }
    
    func activateNewInstallationForDeviceId(deviceId: String)
    {
        // set up request
        let activationUrl = NSURL(string: kActivationUrlMinusDeviceId + deviceId)
        let request = NSMutableURLRequest(URL: activationUrl!)
        request.setValue(authenticationString(), forKey: kHttpHeaderFieldAuthorization)
        
        var returningResponse: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error: NSErrorPointer = nil
        let responseData = NSURLConnection.sendSynchronousRequest(request, returningResponse: returningResponse, error: error)
        
        // TODO:
        if error == nil
        {
            let parser = NSXMLParser(data: responseData!)
            parser.delegate = self
            
            parser.parse() // see delegate methods for setting installation id
        }
        else
        {
            let alert = UIAlertView(title: "Error", message: ":(", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    // MARK: - NSXMLParserDelegate
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        isReadingAuthToken = false
        
        if elementName == "authToken"
        {
            isReadingAuthToken = true
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?)
    {
        if isReadingAuthToken
        {
            installationId = string
        }
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
    
    func authenticationString() -> NSString
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