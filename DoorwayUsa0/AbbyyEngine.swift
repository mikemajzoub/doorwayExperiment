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
    func retrievedText(textFromPicture: String)
}

class AbbyyEngine: NSObject, NSXMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
{
    enum ConnectionState
    {
        case NoActivity
        case Uploading
        case Processing
        case Downloading
    }
    
    let kHttpHeaderFieldAuthorization = "Authorization"
    let kHttpMethodPost = "POST"
    /// let kProcessImageUrlMinusParameters = "http://cloud.ocrsdk.com/processImage?"
    /// let kProcessImageParameters = "language=English&exportFormat=txt"
    let kProcessTextFieldUrlMinusParameters = "http://cloud.ocrsdk.com/processTextField?"
    let kConstantParameters = "letterSet=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,'&textType=handprinted&oneTextLine=true&writingStyle=american"
    
    
    
    // Delegate
    weak var delegate: AbbyyEngineDelegate?
    
    // Credentials
    var applicationId: String!
    var applicationPassword: String!
    var fullId: String!
    
    // XML Parser
    var xmlId: String!
    var xmlStatus: String!
    var xmlUrl: NSURL!
    
    // NSURL
    var receivedData = NSMutableData()
    
    // State of Client-Server Interaction
    var connectionState: ConnectionState?
    
    // MARK: - Init
    override init()
    {
        super.init()
        
        connectionState = .NoActivity
        
        applicationId = ABBYY_APPLICATION_ID
        applicationPassword = ABBYY_APPLICATION_PASSWORD
    }
    
    // MARK: - Logic
    func processImage(takenPicture: UIImage?, withAnswer answer: String)
    {
        if let image = takenPicture
        {
            sendPhoto(takenPicture as UIImage!, withAnswer: answer)
        }
    }
    
    func sendPhoto(photoToSend: UIImage, withAnswer answer: String)
    {
        connectionState = .Uploading
        
        let regExParameter = "&regExp=(\(answer))"
        let parameters = kConstantParameters + regExParameter
        
        let url = NSURL(string: (kProcessTextFieldUrlMinusParameters + parameters))
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = kHttpMethodPost
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = UIImageJPEGRepresentation(photoToSend as UIImage!, 0.5)
        request.setValue(authenticationString() as String, forHTTPHeaderField: kHttpHeaderFieldAuthorization)
        
        let connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        connection?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        connection?.start()
    }
    
    func uploadingFinished(error: NSError?)
    {
        connectionState = .Processing

        let parser = NSXMLParser(data: receivedData)
        parser.delegate = self
        parser.parse()
        
        let url = NSURL(string: ("http://cloud.ocrsdk.com/getTaskStatus?taskId=" + xmlId))
        let request = NSMutableURLRequest(URL:url!)
        request.setValue(authenticationString() as String, forHTTPHeaderField: kHttpHeaderFieldAuthorization)
        
        let connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        connection?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        connection?.start()
    }
    
    func processingFinished(error: NSError?)
    {
        let parser = NSXMLParser(data: receivedData)
        parser.delegate = self
        parser.parse()

        if xmlStatus == "Completed"
        {
            connectionState = .Downloading
            
            let request = NSURLRequest(URL: xmlUrl)
            let connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
            connection?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            connection?.start()
        }
        else
        {
            uploadingFinished(nil)
        }
    }
    
    func downloadingFinished(error: NSError?)
    {
        connectionState = .NoActivity
        
        let result = NSString(data:receivedData, encoding:NSUTF8StringEncoding) as! String
        
        delegate?.retrievedText(result)
    }
    
    func authenticationString() -> String
    {
        let authentication = NSString(format: "%@:%@", applicationId, applicationPassword)
        let authenticationData: NSData = authentication.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Authentication = authenticationData.base64EncodedStringWithOptions(nil)
        let fullAuthenticationString = "Basic \(base64Authentication)"
        
        return fullAuthenticationString
    }
    
    func stopEngine()
    {
        connectionState = .NoActivity
    }
    
    // MARK: - NSXMLParserDelegate
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
        println("elementName:\(elementName)")
        println("dict:\(attributeDict)")
        
        if elementName == "task"
        {
            xmlId = attributeDict["id"] as! String
            xmlStatus = attributeDict["status"] as! String
            
            if xmlStatus == "Completed"
            {
                let urlString = attributeDict["resultUrl"] as! String
                xmlUrl = NSURL(string: urlString)

            }
            else if elementName == "error"
            {
                // TODO:
            }
        }
    }
    
    // MARK: - NSURLConnectionDelegate
    
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool
    {
        return true
    }
    
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge)
    {
        if challenge.previousFailureCount == 0
        {
            let credential = NSURLCredential(user: applicationId, password: applicationPassword, persistence: NSURLCredentialPersistence.ForSession)
            challenge.sender.useCredential(credential, forAuthenticationChallenge: challenge)
        }
        else
        {
            challenge.sender.cancelAuthenticationChallenge(challenge)
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError)
    {
        if connectionState == .Uploading
        {
            uploadingFinished(error)
        }
        else if connectionState == .Processing
        {
            processingFinished(error)
        }
        else if connectionState == .Downloading
        {
            downloadingFinished(error)
        }
    }
    
    // MARK: - NSURLConnectionDataDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
    {
        receivedData.length = 0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData)
    {
        receivedData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        if connectionState == .Uploading
        {
            uploadingFinished(nil)
        }
        else if connectionState == .Processing
        {
            processingFinished(nil)
        }
        else if connectionState == .Downloading
        {
            downloadingFinished(nil)
        }
    }
}