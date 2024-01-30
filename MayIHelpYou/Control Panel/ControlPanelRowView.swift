//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import SwiftUI

struct ControlPanelRowView: View {
	@EnvironmentObject private var colorManager:ColorManager
	// MARK: - PROPERTIES
	
	var name: String
	var content: String? = nil
//	var linkLabel: String? = nil
//	var linkDestination: String? = nil
	
	// MARK: - BODY
	
	var body: some View {
		VStack {
			Divider().padding(.vertical, 4)
			
			if #available(iOS 16.0, *) {
				LabeledContent(name, value: content ?? "")
			} else {
				HStack {
					Text(name).foregroundColor(colorManager.current.disabled)
					Spacer()
					if (content != nil) {
						Text(content!)
					}
					else {
						EmptyView()
					}
				}
			}
		}
	}
}

// MARK: - PREVIEW

struct SettingsRowView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			ControlPanelRowView(name: "Developer", content: "John / Jane")
				.environmentObject(ColorManager())
				.previewLayout(.fixed(width: 375, height: 60))
				.padding()
			ControlPanelRowView(name: "Website")
				.environmentObject(ColorManager())
				.preferredColorScheme(.dark)
				.previewLayout(.fixed(width: 375, height: 60))
				.padding()
		}
	}
}
