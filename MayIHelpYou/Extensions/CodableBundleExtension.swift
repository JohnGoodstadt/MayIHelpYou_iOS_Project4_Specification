//
//  CodableBundleExtension.swift
//  Pronounce It
//
//  Created by John goodstadt on 07/02/2023.
//

import Foundation

extension Bundle {
	func decode<T: Codable>(_ file: String) -> T {
		// 1. Locate the json file
		guard let url = self.url(forResource: file, withExtension: nil) else {
			fatalError("Failed to locate \(file) in bundle.")
		}
		
		// 2. Create a property for the data
		guard let data = try? Data(contentsOf: url) else {
			fatalError("Failed to load \(file) from bundle.")
		}
		
		// 3. Create a decoder
		let decoder = JSONDecoder()
		
		do{
			// 4. Create a property for the decoded data
			let loaded = try decoder.decode(T.self, from: data)
			
			return loaded
			
		}catch {
			print(file)
			print(error)
			fatalError("Failed to decode '\(file)' from bundle.")
		}
	}
}
