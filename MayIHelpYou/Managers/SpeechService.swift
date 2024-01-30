//
//  SpeechService.swift
//  Google TTS Demo
//
//  Created by Alejandro Cotilla on 5/30/18.
//  Copyright © 2018 Alejandro Cotilla. All rights reserved.
//

import UIKit
import AVFoundation

//fileprivate enum VoiceNameUS: String {
//	case undefined
//	case waveNetFemale = "en-US-Wavenet-F"
//	case waveNetMale = "en-US-Wavenet-D"
//	case standardFemale = "en-US-Standard-E"
//	case standardMale = "en-US-Standard-D"
//}
//
//private enum VoiceNameAU: String {
//    case undefined
//    case waveNetFemale = "en-AU-Wavenet-A"  //Male
//    case waveNetMale = "en-AU-Wavenet-B"	//Female
//    case standardFemale = "en-AU-Wavenet-C" //Female
//    case standardMale = "en-AU-Wavenet-D" //Male
//}

fileprivate let ttsAPIUrl = "https://texttospeech.googleapis.com/v1beta1/text:synthesize"
fileprivate let APIKey = "AIzaSyA6pHsc1LdrsDuCm1cBjADvwDDI6a3e6Xk"

class SpeechService: NSObject, AVAudioPlayerDelegate {

	enum SpeechError: Error {
		case busyError
		case returnedDataBadFormat
		case invalidResponseError
	}
	
    static let shared = SpeechService()
    private(set) var busy: Bool = false
    
    private var player: AVAudioPlayer?
    private var completionHandler: (((Result<Bool, Error>)) -> Void)?
    
	func speak(text: String, voiceName:String, completion: @escaping ((Result<Bool, Error>)) -> Void) {
        guard !self.busy else {
            print("Speech Service busy!")
			completion(.failure(SpeechError.busyError))
			return
        }
        
        self.busy = true
		//AIzaSyA6pHsc1LdrsDuCm1cBjADvwDDI6a3e6Xk -- iOS
		//AIzaSyD1tgyvEGVDmHZHk_ORcvSVPwipKA6588k  -- browser
		//AIzaSyDgeL6pu6a2MhngHOueltFNbeCibNPlHZ8 -- mine
        DispatchQueue.global(qos: .background).async {
			let postData = self.buildPostData(text: text, voiceName: voiceName)
            let headers = ["X-Goog-Api-Key": APIKey, "Content-Type": "application/json; charset=utf-8"]
            let response = self.makePOSTRequest(url: ttsAPIUrl, postData: postData, headers: headers)

            // Get the `audioContent` (as a base64 encoded string) from the response.
            guard let audioContent = response["audioContent"] as? String else {
                print("Invalid response: \(response)")
                self.busy = false
                DispatchQueue.main.async {
					completion(.failure(SpeechError.invalidResponseError))
                }
                return
            }
            
            // Decode the base64 string into a Data object
            guard let audioData = Data(base64Encoded: audioContent) else {
                self.busy = false
                DispatchQueue.main.async {
					completion(.failure(SpeechError.returnedDataBadFormat))
                }
                return
            }
            
            DispatchQueue.main.async {
				print("saving mp3 to:\(getDocumentsDirectory())")
				cacheMP3Locally("12345",audioData)
                self.completionHandler = completion
                self.player = try! AVAudioPlayer(data: audioData)
                self.player?.delegate = self
                self.player!.play()
            }
        }
    }
    
//	private func buildPostData(text: String, voiceType: VoiceNameAU) -> Data {
	private func buildPostData(text: String, voiceName:String) -> Data {
        
        var voiceParams: [String: Any] = [
            // All available voices here: https://cloud.google.com/text-to-speech/docs/voices
//            "languageCode": "en-US"
			"languageCode": "en-AU"
        ]
        
		guard voiceName != "Not Available" else{
			print("No voice available")
			return Data()
		}
		
        if voiceName != "Not Available" {
            voiceParams["name"] = voiceName//voiceType.rawValue
        }
        
        let params: [String: Any] = [
            "input": [
                "text": text
            ],
            "voice": voiceParams,
            "audioConfig": [
                // All available formats here: https://cloud.google.com/text-to-speech/docs/reference/rest/v1beta1/text/synthesize#audioencoding
                "audioEncoding": "LINEAR16"
            ]
        ]

        // Convert the Dictionary to Data
        let data = try! JSONSerialization.data(withJSONObject: params)
        return data
    }
    
    // Just a function that makes a POST request.
    private func makePOSTRequest(url: String, postData: Data, headers: [String: String] = [:]) -> [String: AnyObject] {
        var dict: [String: AnyObject] = [:]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        // Using semaphore to make request synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
//                dict = json!
				dict = json
            }
            
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return dict
    }
    
    // Implement AVAudioPlayerDelegate "did finish" callback to cleanup and notify listener of completion.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		print("audioPlayerDidFinishPlaying")
        self.player?.delegate = nil
        self.player = nil
		if self.busy {
			print("audioPlayerDidFinishPlaying isBusy !!")
		}
        self.busy = false
        
		self.completionHandler!(.success(true))
        self.completionHandler = nil
    }
}
