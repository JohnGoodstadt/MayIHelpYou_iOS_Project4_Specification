//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import SwiftUI

struct ControlPanelSwitchView: View {
	// MARK: - PROPERTIES
	
	var name: String
	@Binding var switchControl:Bool
	// MARK: - BODY
	
	var body: some View {
		VStack {
			Divider().padding(.vertical, 4)
			
			HStack {
				Text(name)
				Spacer()
				Toggle("", isOn: $switchControl)
			}
		}
		
	}
}

// MARK: - PREVIEW

struct ControlPanelSwitchView_Previews: PreviewProvider {
	
	@State static var switchControl:Bool = true
	
	static var previews: some View {
		Group {
			ControlPanelSwitchView(name: "Developer", switchControl: $switchControl)
				.previewLayout(.fixed(width: 375, height: 60))
				.padding()
		
		}
	}
}
