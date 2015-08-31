//
//  OpenEarsEngine.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/30/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

class OpenEarsEngine: NSObject, OEEventsObserverDelegate
{
    var lmPath: String!
    var dicPath: String!
    var words: Array<String> = ["I WALKED THE DOG", "HEY"]
    
    var openEarsEventsObserver: OEEventsObserver!
    var openEarsFliteController: OEFliteController!
    var slt: Slt!
    
    // MARK: - Init
    override init()
    {
        super.init()
        
        // Speech
        self.openEarsFliteController = OEFliteController()
        self.slt = Slt()
        
        // Listening
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
        
        // Listening Language Model????????????????????????????????????????????????????
        var lmGenerator: OELanguageModelGenerator = OELanguageModelGenerator()
        
        var name = "LanguageModelFileStarSaver"
        lmGenerator.generateLanguageModelFromArray(words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
        
        lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
        dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
    }
    
    
    // MARK: - Listening
    func startListening() {
        OEPocketsphinxController.sharedInstance().setActive(true, error: nil)
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
    }
    
    func stopListening() {
        OEPocketsphinxController.sharedInstance().stopListening()
    }
    
    // MARK: - Speech
    func say(sayThis: String)
    {
        self.openEarsFliteController.say(sayThis, withVoice:self.slt)
    }
    
    // MARK: - OpenEars Delegate
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        println("The received hypothesis is \(hypothesis) with a score of \(recognitionScore) and an ID of \(utteranceID)")
    }
    
    func pocketsphinxDidStartListening() {
        println("Pocketsphinx is now listening.")
    }
    
    func pocketsphinxDidDetectSpeech() {
        println("Pocketsphinx has detected speech.")
    }
    
    func pocketsphinxDidDetectFinishedSpeech() {
        println("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }
    
    func pocketsphinxDidStopListening() {
        println("Pocketsphinx has stopped listening.")
    }
    
    func pocketsphinxDidSuspendRecognition() {
        println("Pocketsphinx has suspended recognition.")
    }
    
    func pocketsphinxDidResumeRecognition() {
        println("Pocketsphinx has resumed recognition.")
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String, newDictionaryPathAsString: String) {
        println("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
    }
    
    func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String) {
        println("Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String) {
        println("Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    func testRecognitionCompleted() {
        println("A test file that was submitted for recognition is now complete.")
    }
}
