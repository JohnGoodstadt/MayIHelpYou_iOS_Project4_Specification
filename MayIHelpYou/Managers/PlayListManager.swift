//
//  PlayListManager.swift
//  PronounceIt
//
//  Created by John goodstadt on 24/02/2023.
//

import Foundation

class UIDAudio{
	var UID:String
	var audio:Data
	var audioname:String
	var title:String
	
	
	init(UID:String,audio:Data,title:String){
		self.UID = UID
		self.audio = audio
		self.title = title
		self.audioname = ""
	}
	
	init(UID:String,audioname:String,title:String){
		self.UID = UID
		self.audio = Data()
		self.title = title
		self.audioname = audioname
	}
}

public let MINIMUM_AUDIO_SIZE = 1

class PlayListManager {
	private var playlistQ = Queue<UIDAudio>()
	private var lastPlayedUID = ""
	
	//MARK: playlist properties
	 func createPlaylist(){
		playlistQ.clear()
	}
	var playlistQueueNew: Queue<UIDAudio>  {
		playlistQ
	}
	func playlistQueue() -> Queue<UIDAudio> {
		playlistQ
	}
	func isPlaylistEmpty() -> Bool{
		return playlistQ.getElements.isEmpty
	}
	func isPlaylistNotEmpty() -> Bool{
		return !isPlaylistEmpty()
	}
	func getPlayListCount() -> Int {
		return playlistQ.getElements.count
	}

	func addAudio(UID:String, audioName:String, title:String = ""){
		let entry = UIDAudio(UID: UID,audioname: audioName, title: title)
	   playlistQ.enqueue(entry)
   }
	
	 func addAudio(_ UID:String,_ audio:Data,_ title:String = ""){
		let entry = UIDAudio(UID: UID,audio: audio, title: title)
		playlistQ.enqueue(entry)
	}

	func isNextAudioPlayable() -> Bool{
		if playlistQ.peek?.audio.count ?? 0 > MINIMUM_AUDIO_SIZE {
			return true
		}else{
			return false
		}
	}
	func isNextAudioUnplayable() -> Bool{
		return !isNextAudioPlayable()
	}
	func readNextAudioUID() -> String {
		return playlistQ.peek?.UID ?? ""
	}
	 func getNextTrack() -> Data{
		let item = playlistQ.dequeue() //FIFO - guaranteed valid mp3
		return item?.audio ?? Data()
	}

	func getEmptyElements() -> [UIDAudio] {
		return playlistQ.getElements.filter { $0.audio.count < MINIMUM_AUDIO_SIZE }
	}
//	func getEmptyElements() -> [UIDAudio] {
//		return playlistQ.getElements.filter { $0.audio.count < MINIMUM_AUDIO_SIZE }
//	}
	func getEmptyElementsCount() -> Int {
		return playlistQ.getElements.filter { $0.audio.count < MINIMUM_AUDIO_SIZE }.count
	}

	func getNextMissingAudios(_ howmany:Int) -> [String] {
		
		let missing = getEmptyElements()
		
		return Array( missing.map { $0.UID }.prefix(howmany) )
		
	}
	func assignAudio(_ UID:String,_ audio:Data) {
		let items = playlistQ.getElements.filter { $0.UID == UID}
		if items.isNotEmpty {
			if let item = items.first {
				item.audio = audio
				print("assigning \(item)")
			}
		}
		
	}
	func debugAudio(_ UID:String){

		let items = playlistQ.getElements.filter { $0.UID == UID}
		if items.isNotEmpty{
			if let item = items.first {
				print(" \(item.audio.count) \(item.title) \(item.UID.prefix(4))")
			}
		}
	}
	func debugAudio(){

		playlistQ.getElements.forEach{
			print("  \($0.audioname ?? "missing") \($0.UID.prefix(8))")
		}
		
		
	}
}
