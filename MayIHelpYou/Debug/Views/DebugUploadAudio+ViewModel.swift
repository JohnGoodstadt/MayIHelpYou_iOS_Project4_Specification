//
//  DebugUploadAudio+ViewModel.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 02/04/2023.
//

import Foundation

extension DebugUploadAudioView {
	@MainActor class ViewModel: ObservableObject {
		
		var mp3s = [String]()
		
		init(){
			let docsPath = Bundle.main.resourcePath! + "/JA64"
			let fileManager = FileManager.default

			do {
				let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath)
				print(docsArray.count)
				let mp3Array = docsArray.filter{$0.contains("mp3")}
				
				
				mp3s = mp3Array.map{ String(String($0.dropFirst(defaultLibraryCode.count+1)).dropLast(4))  }
				
				print(mp3s)
//				print(originalStr.withoutPunctuations)
				
				
				
				
			} catch {
				print(error)
			}
		}
		func lookUpMP3(_ phrase:String) -> Bool {
			
			//exact match
			if mp3s.contains(where: {$0 == phrase.lowercased().withoutPunctuations }) {
				return true
			}
			return false
		}
		func MP3name(_ phrase:String) -> String {
			
			//exact match
			if mp3s.contains(where: {$0 == phrase.lowercased().withoutPunctuations }) {
				return "JA64-" +  phrase.lowercased().withoutPunctuations  + ".mp3"
			}
			return ""
		}
		func lookUpMP3(_ phrase:String) -> String {
			
			//exact match
			if mp3s.contains(where: {$0 == phrase.lowercased().withoutPunctuations }) {
				return "FOUND mp3"//phrase
			}
			
			
//			let stringPath = Bundle.main.path(forResource:phrase, ofType: "mp3")
//			let urlPath = Bundle.main.url(forResource: "input", withExtension: "txt")
//
			return "Not found"
		}

	}
}
