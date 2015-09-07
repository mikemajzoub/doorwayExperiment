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
    var xmlId: String!
    var xmlStatus: String!
    var xmlUrl: NSURL!
    
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
        
        let connection = NSURLConnection(request: processingRequest, delegate: self, startImmediately: true)
        connection?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        connection?.start()
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
        return false
    }
    
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        println("22222")
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("3333")
    }
    
//    ///
//    - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//    {
//    if (self.authenticationDelegate != nil) {
//    return [self.authenticationDelegate httpOperation:self canAuthenticateAgainstProtectionSpace:protectionSpace];
//    }
//    
//    return NO;
//    }
//    
//    - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//    {
//    if (self.authenticationDelegate != nil) {
//    [self.authenticationDelegate httpOperation:self didReceiveAuthenticationChallenge:challenge];
//    } else {
//    if ([challenge previousFailureCount] == 0) {
//    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
//    } else {
//    [[challenge sender] cancelAuthenticationChallenge:challenge];
//    }
//    }
//    }
//    
//    - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//    {
//    [self finishWithError:error];
//    }
    
    
    
    
    
    
    
    // MARK: - NSURLConnectionDataDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        println("4444")
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        println("5555")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        println("6666")
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