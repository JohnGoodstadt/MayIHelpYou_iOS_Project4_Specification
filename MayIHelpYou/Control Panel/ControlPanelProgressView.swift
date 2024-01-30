//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import SwiftUI

struct ControlPanelProgressView: View {
	@EnvironmentObject private var colorManager:ColorManager
	// MARK: - PROPERTIES
	
	var labelText: String
	var labelImage: String
	var completions: [Bool]
	// MARK: - BODY
  //
	var body: some View {
	  HStack {
		Text(labelText)
		Spacer()
		  ForEach(completions,id: \.self){ complete in
			  if complete {
				  Image(systemName: "star.fill").imageScale(.small).font(Font.title.weight(.light)).foregroundColor(colorManager.current.redAMBERGreen)
			  }else{
				  Image(systemName: "star").imageScale(.small).font(Font.title.weight(.light)).foregroundColor(colorManager.current.disabled)
			  }
		  }
	  }
	}
}

// MARK: - PREVIEW
//
struct ControlPanelProgressView_Previews: PreviewProvider {

	static var completions = [true,true,false,false,false]
	
	static var previews: some View {
	  ControlPanelLabelView(labelText: "Progress", labelImage: "star")
		.environmentObject(ColorManager())
		.previewLayout(.sizeThatFits)
		.padding()
	}
}
