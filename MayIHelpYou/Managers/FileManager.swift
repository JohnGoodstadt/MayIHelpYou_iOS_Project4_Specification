//
//  FileManager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 04/04/2023.
//

import Foundation

let mp3_suffix = "mp3"
let jpg_suffix = "jpg"

//single place to calc filename for caching
func makePracticeUID(code:String,voiceName:String,type:String,conversationNumber:Int,questionNumber:Int) -> String {
	
	"\(code)_\(voiceName)_\(type)_\(conversationNumber)_\(questionNumber)"
}

func getCachedAudioIfExists(voicename:String, UID:String) -> Data {
	
	var returnValue = Data()
	
	let filename = "\(voicename)_\(UID).\(mp3_suffix)"
	
	if doesCachedFileExist(filename: filename) {
		let mp3 = readLocallyCachedMP3(filename: filename)
		if mp3.isNotEmpty() {
			returnValue = mp3
		}else{
			print("cannot find mp3 \(UID.prefix(4))")
		}
	}
	
	return returnValue
}
func getCachedAudioIfExists(UID:String) -> Data {
	
	var returnValue = Data()
	
	let filename = "\(UID).\(mp3_suffix)"
	
	if doesCachedFileExist(filename: filename) {
		let mp3 = readLocallyCachedMP3(filename: filename)
		if mp3.isNotEmpty() {
			returnValue = mp3
		}else{
			print("cannot find mp3 \(UID.prefix(4))")
		}
	}
	
	return returnValue
}
func cacheMP3Locally(UID: String,_ mp3: Data) {
	
	let filename = "\(UID).\(mp3_suffix)"
	
	do {
		if !doesCachedFileExist (filename: filename) {
			try mp3.write(to: getDocumentsDirectory().appendingPathComponent(filename))
		}
	} catch {
		print(error)
	}
	
}
func cacheJPGLocally( UID: String,_ image: Data) {
	
	let filename = "\(UID).\(jpg_suffix)"
	
	do {
		if !doesCachedFileExist (filename: filename) {
			try image.write(to: getDocumentsDirectory().appendingPathComponent(filename))
		}
	} catch {
		print(error)
	}
	
}
func cacheMP3Locally(voicename:String, UID: String,_ mp3: Data) {
	
	
	let filename = "\(voicename)_\(UID).\(mp3_suffix)"
	
	
	
	do {
		if !doesCachedFileExist (filename: filename) {
			try mp3.write(to: getDocumentsDirectory().appendingPathComponent(filename))
		}
	} catch {
		print(error)
	}
	
}
func doesCachedMP3FileExist(UID:String) -> Bool {
	
	let filename = "\(UID).\(mp3_suffix)"
	
	return exists(getDocumentsDirectory().appendingPathComponent(filename))
}
func doesCachedFileExist(filename:String) -> Bool {
	
	return exists(getDocumentsDirectory().appendingPathComponent(filename))
}
func exists(_ name:URL ) -> Bool
{
	FileManager.default.fileExists(atPath: name.path)

}
func readLocallyCachedMP3(filename:String) -> Data {
	
	//let filename = "\(UID).\(mp3_suffix)"
	
	do{
		return try Data(contentsOf: getDocumentsDirectory().appendingPathComponent(filename))
	}catch{
		print(error)
	}
	
	
	return Data()
	
}
func readLocallyCachedMP3(_ url: URL) -> Data {
	
	do{
		if url.startAccessingSecurityScopedResource() {
			return try Data(contentsOf: url)
		}
		url.stopAccessingSecurityScopedResource()
		
	}catch{
		print(error)
	}
	
	
	return Data()
	
}

//MARK: - file paths
func getDocumentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	let documentsDirectory = paths[0]
	return documentsDirectory
}
func getDocumentsDirectoryString() -> String {
	let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
	let documentsDirectory = paths[0]
	return documentsDirectory
}

/// delete any score images with matching UID in name
///
/// - Parameters:
///   - UID: used to calc full name
///
///   e.g. if only file is recallGroup_9857CA13-8516-454B-947B-C0F5A5F2959A_1 and parm is '9857CA13-8516-454B-947B-C0F5A5F2959A' then delete file
public func removeAllFilesBySuffix(_ suffix:String) {
	// be careful - will delate all for suffix's
	do {
		let dirContents = try FileManager.default.contentsOfDirectory(atPath: getDocumentsDirectoryString())
		let filter = NSPredicate(format:"self LIKE '*.\(suffix)'")
		let onlySuffixes = dirContents.filter() { filter.evaluate(with: $0) }
		
		
		for name in onlySuffixes {
			removeFile(name)
		}
		
		
	}catch {
		print("file manager error \(error)")
	}
	
	
}
/// delete filename
///
/// - Parameters:
///   - filename: filename to delete from Documents
///
public func removeFile(_ filename:String?){
	
	guard let name = filename else {
		return
	}
	
	guard name.count > 0 else {
		return
	}
	
	
	let f = getDocumentsDirectory().appendingPathComponent(name)
	
	do{
		try FileManager.default.removeItem(at: f)
	}catch{
		print(error)
	}
	
}
