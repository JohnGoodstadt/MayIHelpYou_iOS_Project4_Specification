//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//

import SwiftUI

struct ControlPanelLabelView: View {
  // MARK: - PROPERTIES
  
  var labelText: String
  var labelImage: String

  // MARK: - BODY
//
  var body: some View {
    HStack {
      Text(labelText.uppercased()).fontWeight(.bold)
      Spacer()
      Image(systemName: labelImage)
			.font(Font.title.weight(.light))
    }
  }
}

// MARK: - PREVIEW

struct SettingsLabelView_Previews: PreviewProvider {
  static var previews: some View {
    ControlPanelLabelView(labelText: "Bridge", labelImage: "info.circle")
      .previewLayout(.sizeThatFits)
      .padding()
  }
}
