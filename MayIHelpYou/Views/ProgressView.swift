//
//  ProgressView.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 22/04/2023.
//

import SwiftUI

struct ProgressView: View {
	@State var value = 0
	var maximum = 5
	var body: some View {
		VStack(alignment: .leading) {
			Text("SegmentedProgressView example")
				.font(.headline)
			Text("Current value is \(value) out of \(maximum)")
				.font(.body)
			SegmentedProgressView(value: value, maximum: maximum,
								  selectedColor:.accentColor,
								  unselectedColor:Color.secondary.opacity(0.3))
				.animation(.default)
				.padding(.vertical)
			Button(action: {
				self.value = (self.value + 1) % (self.maximum + 1)
			}) {
				Text("Increment value")
			}
			
			Button(action: {
				self.value = (self.value - 1) % (self.maximum + 1)
			}) {
				Text("Decrement value")
			}
		}
		.padding()
	}
}

struct SegmentedProgressViewMoved: View {
	var value: Int
	var maximum: Int = 7
	var height: CGFloat = 10
	var spacing: CGFloat = 2
	var selectedColor: Color = .accentColor
	var unselectedColor: Color = Color.secondary.opacity(0.3)
	
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

struct ProgressView_Previews: PreviewProvider {
	static var previews: some View {
		ProgressView()
	}
}
