//
//  DebugUploadAudio.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 02/04/2023.
//

import SwiftUI

struct DebugUploadAudioView: View {
//	@EnvironmentObject private var dataManager:DataManager
//	@StateObject private var viewModel = ViewModel()
//
//	@State private var selection: String?
//	private var audioManager = AudioManager()
	var body: some View {
		
		NavigationView {
			Text("Hello")
				.navigationTitle("Nav Title")
		}
		
		#if DONT_COMPILE
//		List(dataManager.phrases,id: \.self,selection: $selection){ phrase in
//
//			VStack (alignment: .leading) {
//				Text(phrase.phrase)
////				Text("JA64-how may i help")\()
////				Text(viewModel.lookUpMP3(phrase.phrase))
//				Button(action: {
//					print("Playing \(phrase.id)")
//					if viewModel.lookUpMP3(phrase.phrase) {
//						audioManager.playTrackFromBundle(viewModel.MP3name(phrase.phrase) )
//					}
//						 // Save the object into a global store to be used later on
//						 //self.viewModel.selectedItem = item
//						 // Present new view
//						 //self.link.presented?.value = true
//					 }) {
//						 Text(viewModel.lookUpMP3(phrase.phrase) ?  "Play" : "")
//					 }
//			}
//
//		}
		
		#endif
	}

}


extension DebugUploadAudioView: AudioLibraryDelegate999 {
	
	mutating func audioPlayerDidFinishPlaying999(UID: String) {
		print("audioPlayerDidFinishPlaying999()")
	}
}
struct DebugUploadAudioView_Previews: PreviewProvider {
	static var previews: some View {
		DebugUploadAudioView()
			.environmentObject(DataManager())
	}
}
