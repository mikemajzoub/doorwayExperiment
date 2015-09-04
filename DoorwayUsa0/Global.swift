//
//  Global.swift
//  DoorwayUsa0
//
//  Created by Michael Majzoub on 9/3/15.
//  Copyright (c) 2015 mikemajzoub. All rights reserved.
//


// TODO: I don't like this at all. Refactor once you how to do this elegantly in Swift.

// Learning Mode
enum LearningMode
{
    case Civics
    case Reading
    case Writing
}

var currentLearningMode: LearningMode?

// Weigh questions and words to determine probability of being quizzed in future.
let ORIGINAL_WEIGHT = 256