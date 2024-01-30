//
//  View.swift
//  May I Help You?
//
//  Created by John goodstadt on 22/03/2023.
//

import SwiftUI

extension View {
	//https://www.avanderlee.com/swiftui/conditional-view-modifier/
	/// Applies the given transform if the given condition evaluates to `true`.
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - transform: The transform to apply to the source `View`.
	/// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
	
	/// Hide or show the view based on a boolean value.
	///
	/// Example for visibility:
	///
	///     Text("Label")
	///         .isHidden(true)
	///
	/// Example for complete removal:
	///
	///     Text("Label")
	///         .isHidden(true, remove: true)
	///
	/// - Parameters:
	///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
	///   - remove: Boolean value indicating whether or not to remove the view.
	@ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
		if hidden {
			if !remove {
				self.hidden()
			}
		} else {
			self
		}
	}
}
