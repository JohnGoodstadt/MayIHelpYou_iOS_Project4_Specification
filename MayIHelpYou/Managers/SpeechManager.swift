//
//  SpeechManager.swift
//  May I Help You?
//
//  Created by John goodstadt on 18/03/2023.
//

import Foundation
import SwiftUI
import AVFoundation

protocol SpeechManagerDelegate {
	func speakerDidFinishSpeaking(phraseUID:String)
}

final class SpeechManager: NSObject {
	
	let synthesizer = AVSpeechSynthesizer()
	var delegate:SpeechManagerDelegate?
	var stringUID:String = ""
	
	override init(){
		super.init()
		synthesizer.delegate = self
	}
	func speakString(_ string:String, UID:String,caller_delegate:SpeechManagerDelegate) {
		
		delegate = caller_delegate
		stringUID = UID
		
		let utterance = AVSpeechUtterance(string: string)
		utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
		
		synthesizer.speak(utterance)
		
	}
}


extension SpeechManager: AVSpeechSynthesizerDelegate {
	
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		delegate?.speakerDidFinishSpeaking(phraseUID: stringUID)
	}
	
}
