//
//  ProgressView.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 22/04/2023.
//

import SwiftUI

struct LessonProgressView: View {
	@EnvironmentObject private var colorManager:ColorManager
	@Binding var lessonProgressValue:Int// = 2
	var maximum = 5
	
	var body: some View {
		VStack(alignment: .leading) {

			if lessonProgressValue == maximum {
				SegmentedProgressView(value: lessonProgressValue,
									  maximum: maximum,
									  selectedColor:colorManager.current.redAmberGREEN,
									  unselectedColor:Color.secondary.opacity(0.3))
					.animation(.default)
					.padding(.vertical)
			}else{
				SegmentedProgressView(value: lessonProgressValue,
									  maximum: maximum,
									  selectedColor:colorManager.current.redAMBERGreen,
									  unselectedColor:Color.secondary.opacity(0.3))
					.animation(.default)
					.padding(.vertical)
			}
			

		}
	}
}
//:TODO Move this
struct SegmentedProgressView: View {
	var value: Int
	var maximum: Int = 7
	var height: CGFloat = 10
	var spacing: CGFloat = 2
	var selectedColor: Color// = .accentColour
	var unselectedColor: Color// = Colour.secondary.opacity(0.3)
	
	var body: some View {
		HStack(spacing: spacing) {
			ForEach(0 ..< maximum) { index in
				Rectangle()
					.foregroundColor(index < self.value ? self.selectedColor : self.unselectedColor)
			}
		}
		.frame(maxHeight: height)
		.clipShape(Capsule())
	}
}

struct LessonProgressView_Previews: PreviewProvider {
	
	static var previews: some View {
		LessonProgressView(lessonProgressValue: .constant(2),maximum: 4)
	}
}
