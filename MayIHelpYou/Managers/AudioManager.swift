//
//  LibraryMP3.swift
//  Iyenga Yoga
//
//  Created by John goodstadt on 16/11/2021.
//

import Foundation
import AVFoundation

protocol AudioLibraryDelegate999 {
	
	mutating func audioPlayerDidFinishPlaying999(UID:String) //so callers know mp3 has finished
}

public class AudioManager:NSObject {
	
	var audioPlayer: AVAudioPlayer?
	var audioPlayerDelegate:AVAudioPlayerDelegate?
	var callerDelegate: AudioLibraryDelegate999? //this apps delegate telling View caller when track has finished
	
	private var lastPlayedUID = "" //keep track of where we are
	
	func isPlaying() -> Bool {
		
		if let player = self.audioPlayer {
			if player.isPlaying {
				return true
			}
		}
		return false
	}
	func stop() {
		if let player = self.audioPlayer {
			if player.isPlaying {
				player.stop()
			}
		}else{
			print("no ivar audioPlayer")
		}
	}
	func currentTime() ->  Float {
		return Float(audioPlayer?.currentTime ?? 0.0)
	}
	func  playAudio(_ audio:Data){
		
		guard !audio.isEmpty else {
			return
		}
		
		do{
			
			let audioPlayer = try AVAudioPlayer(data: audio , fileTypeHint: "mp3")
			audioPlayer.prepareToPlay()
			audioPlayer.play()
			
		}catch{
			print(error)
		}
		
	}
	func  playAudio(_ audio:Data,UID:String,caller_delegate:AudioLibraryDelegate999){
		
		guard !audio.isEmpty else {
			return
		}
		
		if let ap = audioPlayer {
			if ap.isPlaying {
				print("AUDIO IS STILL PLAYING")
				return
			}
		}
		

		
		do{
			callerDelegate = caller_delegate
			lastPlayedUID = UID
			
			try audioPlayer = AVAudioPlayer(data: audio , fileTypeHint: "mp3")
			audioPlayer?.delegate = self
			audioPlayer?.play()
			
		}catch{
			print(error)
		}
		
	}
	func  playAudio(_ audio:Data,UID:String){ //play and forget
		
		guard !audio.isEmpty else {
			return
		}
		
		do{
			lastPlayedUID = UID
			
			try audioPlayer = AVAudioPlayer(data: audio , fileTypeHint: "mp3")
			audioPlayer?.play()
			
		}catch{
			print(error)
		}
		
	}
	//USED BY ONE SHOW View - merge with playList one
	func  play_1_Mp3(_ name:String,caller_delegate:AudioLibraryDelegate999){
		
		guard !name.isEmpty else{
			return
		}
		
		
		if let mp3 = Bundle.main.url(forResource: name, withExtension: "mp3") {
			do {
				self.callerDelegate = caller_delegate
				//				self.audioPlayerDelegate = self //so we can call audioLibraryDelegate
				try audioPlayer = AVAudioPlayer(contentsOf: mp3)
				audioPlayer?.delegate = self
				audioPlayer?.play()
			} catch {
				print("Couldn't play audio. Error: \(error)")
			}
		}
		
		if let m4a = Bundle.main.url(forResource: name, withExtension: "m4a") {
			do {
				self.callerDelegate = caller_delegate
				//				self.audioPlayerDelegate = self //so we can call audioLibraryDelegate
				try audioPlayer = AVAudioPlayer(contentsOf: m4a)
				audioPlayer?.delegate = self
				audioPlayer?.play()
			} catch {
				print("Couldn't play audio. Error: \(error)")
			}
		}
		
		return
	}
	func  playTrackFromBundle(_ name:String){
		
		guard !name.isEmpty else{
			return
		}
		
		
		if let mp3 = Bundle.main.url(forResource: name, withExtension: "") {
			do {
				try audioPlayer = AVAudioPlayer(contentsOf: mp3)
				audioPlayer?.delegate = self
				audioPlayer?.play()
			} catch {
				print("Couldn't play audio. Error: \(error)")
			}
		}
		
		if let m4a = Bundle.main.url(forResource: name, withExtension: "m4a") {
			do {
				//				self.audioLibraryDelegate = caller_delegate
				try audioPlayer = AVAudioPlayer(contentsOf: m4a)
				audioPlayer?.delegate = self
				audioPlayer?.play()
			} catch {
				print("Couldn't play audio. Error: \(error)")
			}
		}
		
		return
	}
	

	static func mp3existsInBundle(_ name:String) ->  Bool {
		
		var returnValue = false
		
		guard !name.isEmpty else{
			return returnValue
		}
		
		if let _ = Bundle.main.url(forResource: name, withExtension: "mp3") {
			returnValue =  true
		}
		
		return returnValue
	}
	static func mp3durationInBundle(_ name:String) ->  Double {
		
		var returnValue = 1.0
		
		guard !name.isEmpty else{
			return returnValue
		}
		
		if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
			do {
				let player = try AVAudioPlayer(contentsOf: url)
				player.prepareToPlay()
				returnValue =  player.duration
			} catch {
				return returnValue
			}
		}
		
		return returnValue
	}
	
}

extension AudioManager: AVAudioPlayerDelegate {
	
	public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
		print("AudioLibrary.audioPlayerDidFinishPlaying")
		
		self.callerDelegate?.audioPlayerDidFinishPlaying999(UID: lastPlayedUID)
		
	}
	
	
	
	
}
