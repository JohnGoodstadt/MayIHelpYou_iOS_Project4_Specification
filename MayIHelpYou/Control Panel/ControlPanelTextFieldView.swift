//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import SwiftUI

struct ControlPanelTextFieldView: View {
	// MARK: - PROPERTIES
	
	var buttonPressed: () -> Void
	
	var name: String
	@Binding var value:String
	

	// MARK: - BODY
	
	var body: some View {
		VStack {
			Divider().padding(.vertical, 4)
			
			HStack {
				Text(name)
				Spacer()
				TextField(name, text: $value)
					.background(Color(UIColor.systemBackground))
					.fixedSize()
					.multilineTextAlignment(.trailing)
					.border(.gray)
					//.padding()
				
				#if DONT_COMPILE
				Button( action: {
					self.buttonPressed()
				}){
					Text(lessonProgressValue)
						.font(.system(size: 16))
						.padding(5)
						.padding([.leading,.trailing],5)
						.foregroundColor(colorManager.current.baseForeground)

				}
				.background(colorManager.current.buttonBlue) // If you have this
				.cornerRadius(16)         // You also need the cornerRadius here
				#endif
			}
		}
		
	}
}

// MARK: - PREVIEW
//
struct ControlPanelTextFieldView_Previews: PreviewProvider {

	@State static var value = "John Goodstadt"

	static 	func reminderButtonPressed() {
		print("I am the reminderButtonPressed")
	 
	}
	
	static var previews: some View {
		Group {
			ControlPanelTextFieldView(buttonPressed: { self.reminderButtonPressed() }, name: "Username", value: $value)
				.previewLayout(.fixed(width: 375, height: 60))
				.padding()

		}
	}

	func fuctionCalledInPassedClosure() {
		 print("I am the parent")
	 }
}
