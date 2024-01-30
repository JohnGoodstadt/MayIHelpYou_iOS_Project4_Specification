//
//  SpeechService.swift
//  Google TTS Demo
//
//  Created by Alejandro Cotilla on 5/30/18.
//  Copyright © 2018 Alejandro Cotilla. All rights reserved.
//

import UIKit
import AVFoundation


fileprivate let ttsAPIUrl = "https://texttospeech.googleapis.com/v1beta1/text:synthesize"
fileprivate let APIKey = "AIzaSyA6pHsc1LdrsDuCm1cBjADvwDDI6a3e6Xk"

class GoogleSpeechManager: NSObject, AVAudioPlayerDelegate {

	enum SpeechError: Error {
		case busyError
		case returnedDataBadFormat
		case invalidResponseError
	}
	
    static let shared = GoogleSpeechManager()
    private(set) var busy: Bool = false//NOTE: only UI busy not Google
    
    private var player: AVAudioPlayer?
	
	func speak(text: String, voiceName:String, completion: @escaping ((Result<Data, Error>)) -> Void) {
		
		guard text.isNotEmpty else {
			return
		}
		
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
				self.busy = false
				completion(.success(audioData))

			}
		}
	}
	func speakAsync(text: String, voiceName:String) async throws -> Data  {
		
		guard text.isNotEmpty else {
			return Data()
		}
		
		let postData = self.buildPostData(text: text, voiceName: voiceName)
		let headers = ["X-Goog-Api-Key": APIKey, "Content-Type": "application/json; charset=utf-8"]
		let response = self.makePOSTRequest(url: ttsAPIUrl, postData: postData, headers: headers)
		
		// Get the `audioContent` (as a base64 encoded string) from the response.
		guard let audioContent = response["audioContent"] as? String else {
			printhires("Invalid response: \(response)")
			
			return Data()
		}
		
		// Decode the base64 string into a Data object
		guard let audioData = Data(base64Encoded: audioContent) else {
			printhires("Cannot decode stream")
			return Data()
		}
		
		return audioData //only good return
		
	}
	func getVoices(completion: @escaping ((Result<Data, Error>)) -> Void) {

		/*
		 GET https://texttospeech.googleapis.com/v1/voices?languageCode=en-GB&key=[YOUR_API_KEY] HTTP/1.1

		 Authorization: Bearer [YOUR_ACCESS_TOKEN]
		 Accept: application/json
		 
		 */
		
		//if let url = URL(string: "https://texttospeech.googleapis.com/v1/voices?languageCode=en-GB&key=\(APIKey)") {
		if let url = URL(string: "https://texttospeech.googleapis.com/v1/voices?languageCode=en&key=\(APIKey)") {
			let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
				guard let data = data else {
					//print(error)
					DispatchQueue.main.async {
						completion(.failure(SpeechError.invalidResponseError))
					}
					return
				}
				//print(String(data: data, encoding: .utf8)!)
				completion(.success(data))
			}

			task.resume()
			
		}

		

	}
	private func buildPostData(text: String, voiceName:String) -> Data {
		
		
//		var langCode = "en-GB"
		//lang code is first5 chars
		var langCode = voiceName.prefix(5)
		if langCode.count != 5 {
			langCode = "en-GB" //in case
		}
		
		var voiceParams: [String: Any] = [
			
			// All available voices here: https://cloud.google.com/text-to-speech/docs/voices
//            "languageCode": "en-US"
			"languageCode": langCode
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
    
   
}
