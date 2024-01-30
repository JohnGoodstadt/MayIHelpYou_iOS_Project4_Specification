//
//  CommunityTabCategories.swift
//  PronounceIt
//
//  Created by John goodstadt on 18/02/2023.
//

import Foundation
import SwiftUI

class PhraseCategory: Equatable, Hashable, Identifiable, Codable {


	
	let id: Int //Unique id. For now id and lessonNumber are the same
	var categoryNumber:Int = 1//move to lessonNumber
	var title: String //displayable string
	var selected: Bool //which TAB is currently selected
	var additional:String = ""
	var sortNumber:Int = 1 //if the ID is not the same as sort order
	
	var linkTitle:String = ""
	var linkLink:String = ""
	//var linkType:String = ""
	var link:Link = Link(title: "",link: "")
	
	init (id: Int , title: String, selected: Bool) {
		self.id = id
		self.categoryNumber = id
		self.title = title
		self.selected = selected
	}
	
	init (id: Int , title: String, selected: Bool, additional:String) {
		self.id = id
		self.categoryNumber = id
		self.title = title
		self.selected = selected
		self.additional = additional
	}

	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		id =  try values.decodeIfPresent(Int.self, forKey: .id) ?? 1
		
		categoryNumber =  try values.decodeIfPresent(Int.self, forKey: .categoryNumber) ?? 1
		title =  try values.decodeIfPresent(String.self, forKey: .title) ?? ""
		selected =  try values.decodeIfPresent(Bool.self, forKey: .selected) ?? false
		additional =  try values.decodeIfPresent(String.self, forKey: .additional) ?? ""
		sortNumber =  try values.decodeIfPresent(Int.self, forKey: .sortNumber) ?? 0

		linkTitle =  try values.decodeIfPresent(String.self, forKey: .linkTitle) ?? ""
		linkLink =  try values.decodeIfPresent(String.self, forKey: .linkLink) ?? ""
		//linkType =  try values.decodeIfPresent(String.self, forKey: .linkType) ?? ""
		
		link = Link(title:linkTitle,link:linkLink)
		
	}
	static func == (lhs: PhraseCategory, rhs: PhraseCategory) -> Bool {
		lhs.id == rhs.id
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

struct PhraseCategoryStatistic: Hashable, Identifiable, Codable {
	var id:String
	var playedCount:Int = 1
	var createdDate:Date = Date()
	var updatedDate:Date = Date()
}

