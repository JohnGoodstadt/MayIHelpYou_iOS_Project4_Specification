//
//  EmptyTabView.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 12/06/2023.
//

import SwiftUI

struct EmptyTabView: View {
	@EnvironmentObject private var dataManager:DataManager
	
	var text:String
	var debugText:String
	
	var body: some View {
		VStack{
			Text(text)
				.padding()
			
			Text(debugText)
				.padding()
			
		}
		
	}

}

struct EmptyTabView_Previews: PreviewProvider {
	static var previews: some View {
		EmptyTabView(text: "Empty View", debugText: "Some text")
	}
}
