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
    // OpenEars
    var openEarsEventsObserver: OEEventsObserver!
    var openEarsFliteController: OEFliteController!
    var slt: Slt!
    
    // Language Model and Dictionary Paths
    var languageModelPathCivics: String!
    var dictionaryPathCivics: String!
    var languageModelPathReading: String!
    var dictionaryPathReading: String!
    var languageModelPathWriting: String!
    var dictionaryPathWriting: String!
    
    // Play tones for user to know when microphone is active/inactive
    var beginListeningSoundEffectPlayer: AVAudioPlayer!
    var endListeningSoundEffectPlayer: AVAudioPlayer!
    
    // Delegate
    weak var delegate: OpenEarsEngineDelegate?
    
    // MARK: - Init
    override init()
    {
        super.init()
        
        // Set up microphone sound effects.
        if let beginSoundPath = NSBundle.mainBundle().pathForResource("beep-xylo", ofType: "aif")
        {
            if let beginSoundUrl = NSURL(fileURLWithPath: beginSoundPath)
            {
                beginListeningSoundEffectPlayer = AVAudioPlayer(contentsOfURL: beginSoundUrl, error: nil)
            }
        }
        
        if let endSoundPath = NSBundle.mainBundle().pathForResource("beep-holdtone", ofType: "aif")
        {
            if let endSoundUrl = NSURL(fileURLWithPath: endSoundPath)
            {
                endListeningSoundEffectPlayer = AVAudioPlayer(contentsOfURL: endSoundUrl, error: nil)
            }
        }
        
        // Set up speech.
        self.openEarsFliteController = OEFliteController()
        self.slt = Slt()
        
        // Set up listening.
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
    }
    
    func makeLanguageModelLanguageForMode(mode: LearningMode, withLanguage language: [String])
    {
        var languageModelGenerator = OELanguageModelGenerator()
        
        // Hook up generated paths
        if mode == .Civics
        {
            let name = "CivicsLanguageModel"
            languageModelGenerator.generateLanguageModelFromArray(language, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
            
            languageModelPathCivics = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
            dictionaryPathCivics = languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
        }
        else if mode == .Reading
        {
            let name = "ReadingLanguageModel"
            languageModelGenerator.generateLanguageModelFromArray(language, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
            
            languageModelPathReading = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
            dictionaryPathReading = languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
        }
        else // mode == .Writing
        {
            let name = "WritingLanguageModel"
            languageModelGenerator.generateLanguageModelFromArray(language, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
            languageModelPathWriting = languageModelGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
            dictionaryPathWriting = languageModelGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
        }
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
    func startListening()
    {
        let languageModelPath: String
        let dictionaryPath: String
        if currentLearningMode == .Civics
        {
            languageModelPath = languageModelPathCivics
            dictionaryPath = dictionaryPathCivics
        }
        else if currentLearningMode == .Reading
        {
            languageModelPath = languageModelPathReading
            dictionaryPath = dictionaryPathReading
        }
        else // currentLearningMode == .Writing
        {
            languageModelPath = languageModelPathWriting
            dictionaryPath = dictionaryPathWriting
        }
        
        // TODO: you should only do this once per screen - not every time you start listening!
        OEPocketsphinxController.sharedInstance().setActive(true, error: nil)
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(languageModelPath, dictionaryAtPath: dictionaryPath, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
    }
    
    func stopListening()
    {
        OEPocketsphinxController.sharedInstance().stopListening()
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
    
    func pocketsphinxDidStartListening()
    {
        println("Pocketsphinx is now listening.")
    }
    
    func pocketsphinxDidDetectSpeech()
    {
        println("Pocketsphinx has detected speech.")
    }
    
    func pocketsphinxDidDetectFinishedSpeech()
    {
        println("Pocketsphinx has detected a period of silence, concluding an utterance.")
    }
    
    func pocketsphinxDidStopListening()
    {
        println("Pocketsphinx has stopped listening.")
    }
    
    func pocketsphinxDidSuspendRecognition()
    {
        println("Pocketsphinx has suspended recognition.")
        
        // endListeningSoundEffectPlayer.play()
        
        delegate?.computerPausedListening()
    }
    
    func pocketsphinxDidResumeRecognition()
    {
        println("Pocketsphinx has resumed recognition.")
        
        beginListeningSoundEffectPlayer.play()
        
        delegate?.computerResumedListening()
    }
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String, newDictionaryPathAsString: String)
    {
        println("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
    }
    
    func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String)
    {
        println("Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String)
    {
        println("Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    func testRecognitionCompleted()
    {
        println("A test file that was submitted for recognition is now complete.")
    }
    
    func fliteDidFinishSpeaking()
    {
        delegate?.computerFinishedSpeaking()
    }
}