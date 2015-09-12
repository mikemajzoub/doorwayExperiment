# doorwayExperiment

Doorwai is a free iOS app written in Swift that tutors immigrants in the topics covered during the US Naturalization Test. For each of the three test sections (Civics, Reading, and Writing), the app intelligently evaluates the student similarly to how an immigration officer will.

For the writing section of the test, the student listens to a sentence and writes it down on a sheet of paper. Then, using the ABBYY Cloud OCR SDK (www.ocrsdk.com), the app is able to analyze whether or not the written text matches the sentence that was spoken. If the student needs remediation in this area, the app further breaks down which words the student is having difficulty with and tests these before returning to the original practice questions. Each word has a weight, and those words that need more practice will be quizzed more frequently.

For the Civics portion of the exam the student listens to a question, and then verbally replies the answer. Using the OpenEars API (www.politepix.com/openears), the app analyzes the student's answer, measuring it for correctness. Each question is weighted so that questions the student needs to learn will be asked more often, and those the student has mastered will be asked less frequently.

The Reading section of the app functions similarly as the Civics portion. Here the student reads aloud a sentence from the GUI, and via the OpenEars API, the app analyzes the accuracy of what is spoken. Each word has a weight, so words that the student struggles with will be quizzed more often.
