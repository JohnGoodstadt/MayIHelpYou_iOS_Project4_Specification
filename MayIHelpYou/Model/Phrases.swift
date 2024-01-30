//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import SwiftUI
import FirebaseFirestoreSwift

// MARK: - PHRASE DATA MODEL
enum PhraseType:  Comparable, Codable,CustomStringConvertible,Hashable {
//	static func < (lhs: PhraseType, rhs: PhraseType) -> Bool {
//		lhs.rawValue < rhs.rawValue
//	}
	
	case introductions
	case askingQuestions
	case SayingSorry
	case Farewells
	case Christmas
	case NA
	var description : String {
		switch self {
			case .introductions:
				return "introductions"
			case .askingQuestions:
				return "askingQuestions"
			case .SayingSorry:
				return "SayingSorry"
			case .Farewells:
				return "Farewells"
			case .Christmas:
				return "Christmas"
			case .NA:
				return "Not Used"
		}
	}
}

class Phrase:  Codable, Hashable, Equatable, Identifiable, CustomStringConvertible {
	
//	@DocumentID var id:String = UUID().uuidString
	var id:String = UUID().uuidString
	var phraseType:PhraseType = .introductions
	var categoryNumber: Int = 1
	var lessonNumber:Int = 1
	var sortNumber:Int
	var phrase: String = ""
	var additional: String = ""
	var playedCount:Int = 0
	var audio:Data = Data()
	var createdDate: Date = Date()
	var updatedDate: Date = Date()
	var nextDate: Date = Date()
	
	
	var linkTitle:String = ""
	var linkLink:String = ""
//	var linkType:String = ""
	var link:Link = Link(title: "",link: "")
	
	var description: String {
		return "(\(id.prefix(8)).., \(phrase) )"
	}
	
	private init(title:String) {
		self.phraseType = .NA
		self.sortNumber = 1
	}
	init(phraseType:PhraseType,sortNumber:Int,phrase:String,additional:String) {
		self.phrase = phrase
		self.additional = additional
		self.phraseType = phraseType
		self.sortNumber = sortNumber
	}
	init(phrase:String,categoryNumber:Int, lessonNumber:Int) {
		self.phrase = phrase
		self.categoryNumber = categoryNumber
		self.lessonNumber = lessonNumber
		self.sortNumber = 1
	}
	init(phraseType:PhraseType,lessonNumber:Int,sortNumber:Int,phrase:String,additional:String) {
		self.phrase = phrase
		self.additional = additional
		self.phraseType = phraseType
		self.lessonNumber = lessonNumber
		self.sortNumber = sortNumber
		self.link = Link(title: "", link: "")
	}
	init(phraseType:PhraseType,lessonNumber:Int,sortNumber:Int,phrase:String,additional:String, linkTitle:String, linkLink:String, linkType:String) {
		self.phrase = phrase
		self.additional = additional
		self.phraseType = phraseType
		self.lessonNumber = lessonNumber
		self.sortNumber = sortNumber
		self.linkTitle = linkTitle
		self.linkLink = linkLink
//		self.linkType = linkType
		self.link = Link(title: "", link: "")
	}
	init(phraseType:PhraseType,lessonNumber:Int,sortNumber:Int,phrase:String,additional:String, audioName:String) {
		self.phrase = phrase
		self.additional = additional
		self.phraseType = phraseType
		self.lessonNumber = lessonNumber
		self.sortNumber = sortNumber
		self.audio = Data()
		if !audioName.isEmpty {
			if let fileURL = Bundle.main.url(forResource: audioName, withExtension: "mp3") {
				if let fileContents = try? Data(contentsOf: fileURL) {
					self.audio = fileContents
				}
			}
		}
		
		
	}
	convenience init(title:String,additional:String,gradientColors:[String]){

		self.init(title: title)
	}
	convenience init(title:String,additional:String){

		self.init(title: title)
	}
	
	
	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		id =  try values.decodeIfPresent(String.self, forKey: .id) ?? "unknownID"
		//TODO: Now obsolete remove field from DB
		/*
		let phraseType99 =   try values.decodeIfPresent(Int.self, forKey: .phraseType) ?? 0
		switch phraseType99 {
			case 0:phraseType = .introductions
			case 1:phraseType = .askingQuestions
			case 2:phraseType = .SayingSorry
			case 3:phraseType = .Farewells
			case 4:phraseType = .Christmas
			case 5:phraseType = .NA
			default:
				phraseType = .introductions
		}
		*/
		categoryNumber =  try values.decodeIfPresent(Int.self, forKey: .categoryNumber) ?? 1
		lessonNumber =  try values.decodeIfPresent(Int.self, forKey: .lessonNumber) ?? 1
		sortNumber =  try values.decodeIfPresent(Int.self, forKey: .sortNumber) ?? 1
		phrase =  try values.decodeIfPresent(String.self, forKey: .phrase) ?? ""
		additional =  try values.decodeIfPresent(String.self, forKey: .additional) ?? ""
		playedCount =  try values.decodeIfPresent(Int.self, forKey: .playedCount) ?? 0
		audio =  try values.decodeIfPresent(Data.self, forKey: .audio) ?? Data()
		
		//Don't need DB values. write only
		createdDate =  Date(timeIntervalSince1970: 0)
		updatedDate =  Date(timeIntervalSince1970: 0)
		updatedDate =  Date(timeIntervalSince1970: 0) //TODO: Do I need this field?
		
		let linkTitle =  try values.decodeIfPresent(String.self, forKey: .linkTitle) ?? ""
		let linkLink =  try values.decodeIfPresent(String.self, forKey: .linkLink) ?? ""
//		linkType =  try values.decodeIfPresent(String.self, forKey: .linkType) ?? ""
		
		link = Link(title:linkTitle,link:linkLink)
		
	}
	
	static func == (lhs: Phrase, rhs: Phrase) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
}


//Subset of above
struct PhraseStatistic: Hashable, Identifiable, Codable {
	var id:String
	var playedCount:Int = 0
}





