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

struct MultipleChoiceButton: View {

	@Environment(\.colorScheme) var colorScheme

	@Binding var showAnswer: Bool

	
	let id: String
	let question:MCAnswer
	let callback: (MCAnswer)->()
	let callbackSpeak: (MCAnswer)->()
	
	let selectedID : String?
	let size: CGFloat
	let color: Color
	let textSize: CGFloat

	init(
		_ id: String,
		answer:MCAnswer,
		callback: @escaping (MCAnswer)->(),
		callbackSpeak: @escaping (MCAnswer)->(),
		selectedID: String?,
		size: CGFloat = 20,
		color: Color = Color.white,
		textSize: CGFloat = 16,
		showAnswer: Binding<Bool>
		) {
		self.id = id
		self.question = answer
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
			self.callback(self.question)
		}) {
			HStack(alignment: .center, spacing: 10) {
				Image(systemName: self.selectedID == self.question.text ? "largecircle.fill.circle" : "circle")
					.renderingMode(.original)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: self.size, height: self.size)
					.modifier(ColorInvert())
				if showAnswer && self.question.correct {
					Text(self.question.text)
						.lineLimit(2)
						.fixedSize(horizontal: false, vertical: true)
						.frame(maxWidth: .infinity)
						.multilineTextAlignment(.leading)

						.padding()
						.font(Font.system(size: textSize))
//						.fontWeight(.bold)
						.foregroundColor(.black)
						.onTapGesture {
							print("MultipleChoiceButtons.onTapGesture TEXT")
							self.callbackSpeak(self.question)
						}
						.background(Color("ColorPracticeHilight"))
//						.padding()
				}else{
					Text(self.question.text)
						.lineLimit(2)
						.fixedSize(horizontal: false, vertical: true)
						.frame(maxWidth: .infinity)
						.multilineTextAlignment(.leading)
						.lineLimit(nil)
						.padding()
						.font(Font.system(size: textSize))
						.background(Color("ColorPracticeHilight"))
//						.padding()
						.onTapGesture {
							print("MultipleChoiceButtons.onTapGesture TEXT")
							self.callbackSpeak(self.question)
						}
				}
				Spacer()
			} //: HSTACK
//			.lineLimit(4)
			.foregroundColor(self.color)
		}
		.foregroundColor(self.color)
	}
}
struct MCAnswer {
	let text:String
	let correct:Bool
	let incorrectSelected:Int //1 or 2
}
struct MultipleChoiceButtonsGroup: View {

//	let items : [String]
	let answers : [MCAnswer]

	@State var selectedId: String = ""
	@Binding var showAnswer: Bool
	
	let callback: (MCAnswer) -> ()
	let callbackSpeak: (MCAnswer) -> ()

	var body: some View {
		VStack {
			ForEach(0..<answers.count) { index in
				MultipleChoiceButton(self.answers[index].text, answer: self.answers[index],
							callback: self.selectedRadioButtonCallback,
							callbackSpeak: self.selectedTextForSpeechCallback,
							selectedID: self.selectedId,
							showAnswer: self.$showAnswer
				)
			}
		}
//		.border(.black)//
//		.padding(1)//iPhone SE
	}

	func selectedRadioButtonCallback(answer: MCAnswer) {
		print("radioGroupCallback()")
		selectedId = answer.text
		callback(answer)
	}
	func selectedTextForSpeechCallback(answer: MCAnswer) {
		print("selectedTextForSpeechCallback()")
		//select AND speek
		selectedId = answer.text
		callback(answer)
		callbackSpeak(answer)
		
	}
}

