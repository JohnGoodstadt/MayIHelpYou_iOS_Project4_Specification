//
//  DataManager.swift
//  Bridge
//
//  Created by John goodstadt on 23/02/2023.
//

import Foundation


let db_filename = "db.json"
let db_tabsFilename = "dbTabs.json"

class JSONManager: ObservableObject {

	
	
#if DONT_COMPILE
	
	//MARK: - Tabs
	static func loadTabsFromBundle() -> [Lesson]{
		StarterTabs
	}
	

	//MARK: - Cards
	func loadFromBundle() -> [PracticeCard]{
		StarterCards
	}
	static func loadFromDB() -> [PracticeCard]{
		
		do{
			let jsondata1 = try loadJSONFromDocuments(db_filename)
			if let db = try? JSONDecoder().decode([PracticeCard].self, from: jsondata1) {
				print("db.count: \(db.count) cards")
				return db
			}else{
				print("Error Decoding")
				print(getDocumentsDirectoryString())
			}
		}catch{
			print(error)
		}
		
		return [PracticeCard]()
	}
	static func delete(){
		deleteFile(db_filename)
	}
	static func save(db:[PracticeCard]){
		
		let currentWorkingPath = getDocumentsDirectoryString()
		print(currentWorkingPath)
		
		do {
			if let encoded = try? JSONEncoder().encode(db) {
				let destinationURL = URL(fileURLWithPath: currentWorkingPath).appendingPathComponent("\(db_filename)")
				try encoded.write(to: destinationURL, options: .atomicWrite)
			}
		}catch{
			print(error)
		}
		
	}


	static func loadTabsFromDB() -> [Pack]{
		
		do{
			let jsondata1 = try loadJSONFromDocuments(db_tabsFilename)
			if let db = try? JSONDecoder().decode([Pack].self, from: jsondata1) {
				print("db.count: \(db.count) cards")
				return db
			}else{
				print("Error Decoding")
				print(getDocumentsDirectoryString())
			}
		}catch{
			print(error)
		}
		
		return [Pack]()
	}
	static func deleteTabs(){
		deleteFile(db_filename)
	}
	static func saveTabs(db:[Pack]){
		
		let currentWorkingPath = getDocumentsDirectoryString()
		print(currentWorkingPath)
		
		do {
			if let encoded = try? JSONEncoder().encode(db) {
				let destinationURL = URL(fileURLWithPath: currentWorkingPath).appendingPathComponent("\(db_tabsFilename)")
				try encoded.write(to: destinationURL, options: .atomicWrite)
			}
		}catch{
			print(error)
		}
		
	}
	#endif
}
