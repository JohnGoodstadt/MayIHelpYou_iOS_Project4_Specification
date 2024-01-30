//
//  VIPresentationDetent.swift
//  Bridge
//
//  Created by John goodstadt on 06/03/2023.
//

import SwiftUI

enum VIPresentationDetents: Hashable {
	case medium
	case large
	case fraction(CGFloat)
	case height(CGFloat)
	
	@available(iOS 16.0, *)
	func detents() -> PresentationDetent {
		switch self {
				
			case .medium:
				return .medium
			case .large:
				return	.large
			case .fraction(let number):
				return .fraction(number)
			case .height(let number):
				return  .height(number)
		}
	}
}

extension View {
	func viPresentationDetents(_ detents: Set<VIPresentationDetents>) -> some View {
		if #available(iOS 16.0, *) {
			return self.presentationDetents([.medium,.fraction(0.30)])
		} else {
			return self
		}
		
	}
}

struct VIPresentationDetent: View {
	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

struct VIPresentationDetent_Previews: PreviewProvider {
	static var previews: some View {
		VIPresentationDetent()
	}
}
