//
//  SpeechService.swift
//  Timer
//
//  Created by Kyle Lee on 2/13/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechService {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    var voice = AVSpeechSynthesisVoice(language: "en-US")
    
    func say(_ phrase: String) {
        
        guard UIAccessibility.isVoiceOverRunning else { return }
        
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.rate = rate
        utterance.voice = voice
        
        synthesizer.speak(utterance)
    }
    
    func getVoices() {
        
        AVSpeechSynthesisVoice.speechVoices().forEach({ print($0.language) })
    }
}
