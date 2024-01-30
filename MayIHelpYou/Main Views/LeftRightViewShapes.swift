//
//  LeftRightViewShapes.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 10/04/2023.
//

import Foundation
import SwiftUI

struct LeftPartViewShape: Shape {
	let pct: CGFloat
	
	func path(in rect: CGRect) -> Path {
		var p = Path()
		p.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.size.width * pct, height: rect.size.height), cornerSize: .zero)
		return p
	}
}

struct RightPartViewShape: Shape {
	let pct: CGFloat
	
	func path(in rect: CGRect) -> Path {
		var p = Path()
		p.addRoundedRect(in: CGRect(x: rect.size.width * pct, y: 0, width: rect.size.width * (1-pct), height: rect.size.height), cornerSize: .zero)
		return p
	}
} 
