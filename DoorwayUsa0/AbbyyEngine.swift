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

class AbbyyEngine: NSObject, NSXMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate
{
    enum AbbyyMode
    {
        case NoActivity
        case Uploading
        case Processing
        case Downloading
    }
    
    let kInstallationId = "InstallationId"
    let kActivationUrlMinusDeviceId = "http://cloud.ocrsdk.com/activateNewInstallation?deviceId="
    
    let kHttpHeaderFieldAuthorization = "Authorization"
    
    let kProcessImageUrlMinusParameters = "http://cloud.ocrsdk.com/processImage?"
    let kProcessImageParameters = "language=English&exportFormat=txt"
    
    let kHttpMethodPost = "POST"
    
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
    
    // State
    var abbyyMode: AbbyyMode?
    
    
    // MARK: - Init
    override init()
    {
        super.init()
        
        abbyyMode = .NoActivity
        
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
        abbyyMode = .Uploading
        
        let processingUrl = NSURL(string: (kProcessImageUrlMinusParameters + kProcessImageParameters))
        let processingRequest = NSMutableURLRequest(URL: processingUrl!)
        processingRequest.HTTPMethod = kHttpMethodPost
        processingRequest.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        processingRequest.HTTPBody = UIImageJPEGRepresentation(photoToSend as UIImage!, 0.5)
        processingRequest.setValue(authenticationString() as String, forHTTPHeaderField: kHttpHeaderFieldAuthorization)
        
        let connection = NSURLConnection(request: processingRequest, delegate: self, startImmediately: true)
        connection?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        connection?.start()
    }
    
    func uploadingFinished(error: NSError?)
    {
        abbyyMode = .Processing
        
        println("upload finished!")

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
        abbyyMode = .Downloading
        
        println("processing finished!")
        
        let parser = NSXMLParser(data: receivedData)
        parser.delegate = self
        parser.parse()
        
        let request = NSURLRequest(URL: xmlUrl)
        
        let connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
        connection?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        connection?.start()
    }
    
    func downloadingFinished(error: NSError?)
    {
        abbyyMode = .NoActivity
        
        println("downloading finished")
        
        let result = NSString(data:receivedData, encoding:NSUTF8StringEncoding)
        println("the result of all of this is: \(result)")
    }
    
    func authenticationString() -> String
    {
        let authentication = NSString(format: "%@:%@", applicationId, applicationPassword)
        let authenticationData: NSData = authentication.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Authentication = authenticationData.base64EncodedStringWithOptions(nil)
        let fullAuthenticationString = "Basic \(base64Authentication)"
        
        println(fullAuthenticationString)
        
        return fullAuthenticationString
    }
    
    func stopEngine()
    {
        // TODO:
    }
    
    // MARK: - NSXMLParserDelegate
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject])
    {
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
    
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: NSURLProtectionSpace) -> Bool {
        println("11111")
        
        // TODO:
        return false
    }
    
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        println("22222")
        
        // TODO:
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("3333")
        
        if abbyyMode == .Uploading
        {
            uploadingFinished(error)
        }
        else if abbyyMode == .Processing
        {
            processingFinished(error)
        }
        else if abbyyMode == .Downloading
        {
            downloadingFinished(error)
        }
        
    }
    
    // MARK: - NSURLConnectionDataDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        // [_recievedData setLength:0];
        receivedData.length = 0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        // [_recievedData appendData:data];
        receivedData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        // [self finishWithError:nil];
        
        if abbyyMode == .Uploading
        {
            uploadingFinished(nil)
        }
        else if abbyyMode == .Processing
        {
            processingFinished(nil)
        }
        else if abbyyMode == .Downloading
        {
            downloadingFinished(nil)
        }
    }
    
    ///
//    #pragma mark - NSURLConnectionDataDelegate implementation
//    
//    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//    {
//    [_recievedData setLength:0];
//    }
//    
//    - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//    {
//    [_recievedData appendData:data];
//    }
//    
//    - (void)connectionDidFinishLoading:(NSURLConnection *)connection
//    {
//    [self finishWithError:nil];
//    }
//    
    
    

}