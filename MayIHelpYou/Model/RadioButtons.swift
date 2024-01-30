//
//  RadioButtons.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 29/03/2023.
//

import Foundation
import SwiftUI
//NOTE: Do I Need this?
struct ColorInvert: ViewModifier {

	@Environment(\.colorScheme) var colorScheme

	func body(content: Content) -> some View {
		Group {
			if colorScheme == .dark {
				content.colorInvert()
			} else {
				content
			}
		}
	}
}

struct RadioButton: View {

	@Environment(\.colorScheme) var colorScheme

	@Binding var showAnswer: Bool
//	@Binding var correct: String
	
	let id: String
	let callback: (String)->()
	let callbackSpeak: (String)->()
	
	let selectedID : String?
	let size: CGFloat
	let color: Color
	let textSize: CGFloat

	init(
		_ id: String,
		callback: @escaping (String)->(),
		callbackSpeak: @escaping (String)->(),
		selectedID: String?,
		size: CGFloat = 20,
		color: Color = Color.white,
		textSize: CGFloat = 14,
		showAnswer: Binding<Bool>
		) {
		self.id = id
		self.size = size
		self.color = color
		self.textSize = textSize
		self.selectedID = selectedID
		self.callback = callback
		self.callbackSpeak = callbackSpeak
		_showAnswer = showAnswer
	}

	var body: some View {
		Button(action:{
			self.callback(self.id)
		}) {
			HStack(alignment: .center, spacing: 10) {
				Image(systemName: self.selectedID == self.id ? "largecircle.fill.circle" : "circle")
					.renderingMode(.original)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: self.size, height: self.size)
					.modifier(ColorInvert())
				if showAnswer  {
					Text(id)
						.font(Font.system(size: textSize + 2))
						.onTapGesture {
							print("RadioButton.onTapGesture TEXT")
							self.callbackSpeak(self.id)
						}
				}else{
					Text(id)
						.font(Font.system(size: textSize))
						.onTapGesture {
							print("RadioButton.onTapGesture TEXT")
							self.callbackSpeak(self.id)
						}
				}
				Spacer()
			}.foregroundColor(self.color)
		}
		.foregroundColor(self.color)
	}
}
 
struct RadioButtonGroup: View {

	let items : [String]
	//let items : [String]

	@State var selectedId: String = ""
	@Binding var showAnswer: Bool
	
	let callback: (String) -> ()
	let callbackSpeak: (String) -> ()

	var body: some View {
		VStack {
			ForEach(0..<items.count) { index in
				RadioButton(self.items[index],
							callback: self.selectedRadioButtonCallback,
							callbackSpeak: self.selectedTextForSpeechCallback,
							selectedID: self.selectedId,
							showAnswer: self.$showAnswer
				)
			}
		}
		.border(.black)
	}

	func selectedRadioButtonCallback(id: String) {
		//print("radioGroupCallback()")
		selectedId = id
		callback(id)
	}
	func selectedTextForSpeechCallback(id: String) {
		//print("selectedTextForSpeechCallback()")
		//select AND speek
		selectedId = id
		callback(id)
		callbackSpeak(id)
		
	}
}

