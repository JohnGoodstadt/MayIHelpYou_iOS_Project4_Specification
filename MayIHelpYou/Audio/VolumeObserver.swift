//
//  VolumeObserver.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 26/04/2023.
//

import Foundation
import AVFoundation

final class VolumeObserver: ObservableObject {

	@Published var volume: Float = AVAudioSession.sharedInstance().outputVolume

	// Audio session object
	private let session = AVAudioSession.sharedInstance()

	// Observer
	private var progressObserver: NSKeyValueObservation!

	func subscribe() {
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
			try session.setActive(true, options: .notifyOthersOnDeactivation)
		} catch {
			print("cannot activate session")
		}

		progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
			DispatchQueue.main.async {
				self.volume = session.outputVolume
			}
		}
	}

	func unsubscribe() {
		self.progressObserver.invalidate()
	}

	init() {
		subscribe()
	}
}
