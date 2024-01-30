//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import SwiftUI

struct ControlPanelButtonView: View {
	@EnvironmentObject private var colorManager:ColorManager
	
	// MARK: - PROPERTIES
	
	var buttonPressed: () -> Void
	
	var name: String
	var value:String
	

	// MARK: - BODY
	
	var body: some View {
		VStack {
			Divider().padding(.vertical, 4)
			
			HStack {
				Text(name)
				Spacer()
				Button( action: {
					self.buttonPressed()
				}){
					Text(value)
						.font(.system(size: 16))
						.padding(5)
						.padding([.leading,.trailing],5)
						.foregroundColor(colorManager.current.baseForeground)

				}
				.background(colorManager.current.buttonBlue) // If you have this
				.cornerRadius(16)         // You also need the cornerRadius here
			}
		}
		
	}
}

// MARK: - PREVIEW
//
struct ControlPanelButtonView_Previews: PreviewProvider {

	@State static var value = "John Goodstadt"

	static 	func reminderButtonPressed() {
		print("I am the reminderButtonPressed")
	 
	}
	
	static var previews: some View {
		Group {
			ControlPanelButtonView(buttonPressed: { self.reminderButtonPressed() }, name: "Developer", value: value)
				.previewLayout(.fixed(width: 375, height: 60))
				.padding()

		}
	}

	func fuctionCalledInPassedClosure() {
		 print("I am the parent")
	 }
}
