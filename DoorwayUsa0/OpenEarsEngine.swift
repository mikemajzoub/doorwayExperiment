//
//  OpenEarsEngine.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 8/30/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//

protocol OpenEarsEngineDelegate: class
{
    func heardWords(words: String!, withRecognitionScore recognitionScore: String!)
    func computerFinishedSpeaking()
    func computerPausedListening()
    func computerResumedListening()
}

class OpenEarsEngine: NSObject, OEEventsObserverDelegate
{
    var lmPath: String!
    var dicPath: String!
    var words: Array<String>!
    
    var openEarsEventsObserver: OEEventsObserver!
    var openEarsFliteController: OEFliteController!
    var slt: Slt!
    
    weak var delegate: OpenEarsEngineDelegate? // TODO: HOOK UP DELEGATE ON INIT OR SEGUE!!!
    
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
        
        // TODO: learn about this language model, how to switch vocabularies btwn civics/read/write
        // Listening Language Model
        loadWords()
        
        var lmGenerator: OELanguageModelGenerator = OELanguageModelGenerator()
        
        var name = "LanguageModelFileStarSaver"
        lmGenerator.generateLanguageModelFromArray(words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
        
        lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
        dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
    }
    
    func stopEngine()
    {
        OEPocketsphinxController.sharedInstance().stopListening()
        
        // TODO: find correct way to interrupt flite while it is speaking. 
        // Currently functional, but error thrown and this is sloppy.
        // NOTE: No info in documentation, header files, or forums. Hacky fix? ...AVAudioPlayer?
        
        delegate = nil
    }
    
    
    // MARK: - Listening
    func startListening() {
        OEPocketsphinxController.sharedInstance().setActive(true, error: nil)
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
    }
    
    func loadWords()
    {
        words =
            [
                // 1. What is the supreme law of the land?
                "THE CONSTITUTION",
                
                // 2. What does the constitution do?
                "SETS UP THE GOVERNMENT",
                "DEFINES THE GOVERNMENT",
                "PROTECTS BASIC AMERICAN RIGHTS",
                
                // 3. The idea of self-government is in the first three words of the constitution. What are these words?
                "WE THE PEOPLE",
                
                // 4. What is an ammendment?
                "A CHANGE TO THE CONSTITUTION",
                "AN ADDITION TO THE CONSTITUTION",
                
                // 5. What do we call the first ten ammendments to the constitution?
                "THE BILL OF RIGHTS",
                
                // 6. What is one right or freedom from the First Ammendment?
                "SPEECH",
                "RELIGION",
                "ASSEMBLY",
                "PRESS",
                "PETITION THE GOVERNMENT",
                
                // 7. How many ammendments does the constitution have?
                "TWENTY-SEVEN"
                
            ] // vocabulary up through question 6 of civics
    }
    
    // MARK: - Speech
    func say(sayThis: String)
    {
        self.openEarsFliteController.say(sayThis, withVoice:self.slt)
    }
    
    // MARK: - OpenEars Delegate
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!)
    {
        delegate?.heardWords(hypothesis, withRecognitionScore: recognitionScore)
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
        delegate?.computerPausedListening()
    }
    
    func pocketsphinxDidResumeRecognition() {
        println("Pocketsphinx has resumed recognition.")
        delegate?.computerResumedListening()
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
    
    func fliteDidFinishSpeaking()
    {
        delegate?.computerFinishedSpeaking()
    }
}
