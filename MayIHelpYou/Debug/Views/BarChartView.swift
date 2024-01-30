//
//  DebugView.swift
//  May I Help You?
//
//  Created by John goodstadt on 17/03/2023.
//

import SwiftUI

struct BarChartView : View {
	@EnvironmentObject private var colorManager:ColorManager
	@State var percent: Float = 0.0

	init(percentage: Binding<Float>){
		self._percent = percentage
	}

	var body: some View {

		VStack {
			
			HStack {
				Text("Bar Chart View").padding (5)
				Spacer()
				Text("\(String(format: "%02.f", arguments: [self.percent * 100]))%").padding(5)
				
				
			}
			.background(LeftPart(pct: CGFloat(percent)).fill(colorManager.current.redAmberGREEN))
			.background(RightPart(pct: CGFloat(percent)).fill(colorManager.current.redAMBERGreen))
			.padding(10)
			
			
			Button {
				let p = percent + 0.25
				percent = p <= 1.0 ? p : 1.0
			} label: {
				Text("Press me")
			}
			
			
		}
		
		
	}

	struct LeftPart: Shape {
		let pct: CGFloat

		func path(in rect: CGRect) -> Path {
			var p = Path()
			p.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.size.width * pct, height: rect.size.height), cornerSize: .zero)
			return p
		}
	}

	struct RightPart: Shape {
		let pct: CGFloat

		func path(in rect: CGRect) -> Path {
			var p = Path()
			p.addRoundedRect(in: CGRect(x: rect.size.width * pct, y: 0, width: rect.size.width * (1-pct), height: rect.size.height), cornerSize: .zero)
			return p
		}
	}

}

struct BarChartView_Preview: PreviewProvider {
	
	static var previews: some View {
//		BarChartView(percentage: .constant(0.75))
		BarChartView()
	}
}


