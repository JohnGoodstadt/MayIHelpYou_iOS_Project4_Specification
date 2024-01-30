//
//  TimePicker.swift
//  May I Help You?
//
//  Created by John goodstadt on 21/03/2023.
//

import SwiftUI

struct TimePickerView: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var reminderDate:Date// = Date()
	
	var dateChosen: (_ selectedDate:Date) -> Void
	
	var body: some View {
		VStack {
			Text("Tap to set a good reminder time")
				.padding()
			DatePicker("", selection: $reminderDate, displayedComponents: .hourAndMinute)
				.labelsHidden()
				.padding()
			Button("Done", action: {
				print("Time chosen \(reminderDate)")
				//let dc = Calendar.current.dateComponents([.hour, .minute], from: reminderDate)
				self.dateChosen(reminderDate)
				presentationMode.wrappedValue.dismiss()
			})
			.padding()
		}
	}
}

//struct TimePickerView_Previews: PreviewProvider {
//	static var previews: some View {
//		TimePickerView(, dateChosen: getDate())
//	}
//	
//	static func getDate(_ date:Date){
//		print(date)
//	}
//}
