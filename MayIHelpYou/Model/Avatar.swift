//
//  Avatar.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 10/05/2023.
//

import Foundation

enum AvatarArea:Int, Codable {
	case practice
	case changeSettings
	case loginFlow
	case whatsNext
	case help
	case unused
}

struct Avatar: Identifiable, Codable {
	let id = UUID()
	let name: String
	let subTitle:String
	let imgString: String
	var image:Data
	var questionCount: Int = 0
	let voice: String// = "en-AU-News-G" //Peter en-AU-News-G, Matilda en-AU-News-E
	let area:AvatarArea
	let subarea:Int //for Practice this is conversation number
	
	init(name:String,avatarArea:AvatarArea,subTitle:String = "",imgString:String,voice:String = "en-AU-News-E",questionCount:Int = 0,subarea:Int = 0,image:Data = Data()){
		self.name = name
		self.area = avatarArea
		self.subarea = subarea
		self.subTitle = subTitle
		self.imgString = imgString
		self.questionCount = questionCount
		self.voice = voice
		self.image = image
	}
	
	private enum CodingKeys: CodingKey {
		case id// = "id"
		case name// = "name"
		case subTitle// = "subTitle"
		case imgString// = "imgString"
		case image// = "image"
		//case questionCount// = "questionCount" //never written
		case area// = "area"
		case voice// = "voice"
		case subarea// = "subarea"
		
	}
	
//	public required init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//
//		id =  try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
//		name =  try values.decodeIfPresent(String.self, forKey: .name) ?? ""
//
//		subTitle =  try values.decodeIfPresent(String.self, forKey: .subTitle) ?? ""
//		imgString =  try values.decodeIfPresent(String.self, forKey: .imgString) ?? ""
//
//		voice =  try values.decodeIfPresent(String.self, forKey: .voice) ?? ""
//
//		area = .changeSettings
//		questionCount = 0
//		image = Data()
//		subarea = 0
//
//
//	}
}
