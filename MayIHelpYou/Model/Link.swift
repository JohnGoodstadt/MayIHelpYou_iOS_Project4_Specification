//
//  Links.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 17/04/2023.
//

import Foundation

struct Link: Equatable, Hashable, Identifiable, Encodable {

	
	let id = UUID()
	let title:String// = ""
	let link:String// = ""
//	let linkType:String = ""  //pdf, youtube, website link

	init(title:String,link:String){
		self.title = title
		self.link = link
	}
}
