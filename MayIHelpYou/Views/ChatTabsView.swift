//
//  LessonTabsView.swift
//
//  Created by Jonathan Zufi on 8/14/20.
//

import SwiftUI

struct ChatTabsView: View {
	
	@EnvironmentObject private var dataManager:DataManager
	@EnvironmentObject private var colorManager:ColorManager
	var chatCount:Int
	
	@Binding var selectedChatIndex: Int
	@State private var currentIndex: Int = 1
	@Namespace private var ns
	
	init(chatCount:Int, selectedChatIndex: Binding<Int>) {
		self.chatCount = chatCount
		_selectedChatIndex = selectedChatIndex
	}
	
	var body: some View {
		VStack {
			
			ScrollView(.horizontal, showsIndicators: false) {
				
				ScrollViewReader { scrollView in
					
					HStack(spacing: 35) {
					
							ForEach (1...chatCount,id: \.self) { chatNumber in
								if chatNumber == selectedChatIndex {
									ZStack() {
										HStack {
											Text("Chat \(chatNumber)")
												.font(.title3)
												.bold()
												.fontWeight(.black)
												.foregroundColor(colorManager.current.buttonBlue)
												.layoutPriority(1)
										}
										
										VStack() {
											
											Rectangle().frame(height: 2)
												.padding(.top, 20)
										}
										.matchedGeometryEffect(id: "animation", in: ns)
									}
								} else {
									Text("Chat \(chatNumber)")
										.font(.title3)
										.bold()
										.fontWeight(.black)
										.foregroundColor(colorManager.current.buttonBlue)
										.onTapGesture {
											withAnimation {
												currentIndex = chatNumber
												selectedChatIndex = currentIndex
												scrollView.scrollTo(chatNumber)
											}
										}
								}//Selected or Not
							}
					}
					.padding(.leading, 10)
					.padding(.trailing, 10)
				}
			}
		}
		.padding()
	}
}

struct ChatTabsView_Previews: PreviewProvider {
	

	static var previews: some View {
		Group {
			
			ChatTabsView(chatCount: 2, selectedChatIndex: .constant(1))
			
		}
		.environmentObject(DataManager())
	}
}

