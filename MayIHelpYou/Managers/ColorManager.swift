//
//  ColorManager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 25/04/2023.
//
import Foundation
import SwiftUI

protocol SkinColors {
	var segmentSelectedTintColor:Color { get set }
	var segmentBackgroundColor:Color { get set }
	var segmentSelectedTextColor:Color { get set }
	var lessonCardNotCompleteBackground:Color { get set }
	var redAmberGREEN: Color { get set }
	var redAMBERGreen: Color { get set }
	var REDAmberGreen: Color { get set }
	var buttonBlue: Color { get set }
	var backgroundLightGrey: Color { get set }
	var foregroundDarkGrey: Color { get set }
	var disabled: Color { get set}
	var divider: Color { get set}
	var text: Color { get set}
	var baseBackground: Color { get set}
	var baseForeground: Color { get set}
}

@MainActor class ColorManager: ObservableObject {
	@Published  var current:SkinColors
	
	static let shared = ColorManager()
	
	init(){
		current = ChatGPTSkinColors()
	}
	init(otherColors:SkinColors){
		current = otherColors
	}
}

struct DefaultSkinColors:SkinColors {
	
	
	
	var segmentSelectedTintColor: Color = Color("ColorBlueberryDark")
	var segmentBackgroundColor: Color = Color("ColorBlueberryLight")
	var segmentSelectedTextColor: Color = .white
	var lessonCardNotCompleteBackground: Color = Color("ColorAmber")
	var redAmberGREEN: Color = Color("ColorGreen")
	var redAMBERGreen: Color = Color("ColorGreen")
	var REDAmberGreen: Color = Color("ColorGreen")
	var buttonBlue: Color = Color.blue
	var backgroundLightGrey: Color = Color("ColorVeryLightGray")
	var foregroundDarkGrey: Color = .gray
	var disabled: Color = .gray
	var divider: Color = .gray
	var text: Color = .black
	var baseBackground: Color = .white
	var baseForeground: Color = .white
}

struct ChatGPTSkinColors:SkinColors {
	
	
	var segmentSelectedTintColor: Color = Color(red: 0.129, green: 0.588, blue: 0.952) //buttonBlue
	var segmentBackgroundColor: Color = Color(red: 0.529, green: 0.807, blue: 0.98) //light blue button
	var segmentSelectedTextColor: Color = .white
	var lessonCardNotCompleteBackground: Color =  Color(red: 1.0, green: 0.8, blue: 0.0)
	
	//ChatGPT
	var redAmberGREEN: Color = Color(red: 0.29, green: 0.68, blue: 0.345)
	var redAMBERGreen: Color = Color(red: 1.0, green: 0.8, blue: 0.0)
	var REDAmberGreen: Color = Color(red: 1.0, green: 0.2, blue: 0.2)
	var buttonBlue: Color = Color(red: 0.129, green: 0.588, blue: 0.952)
	var backgroundLightGrey: Color = Color(red: 0.941, green: 0.941, blue: 0.941)
	var foregroundDarkGrey: Color = Color(red: 0.941, green: 0.941, blue: 0.941)
	var disabled: Color = .gray
	var divider: Color = .gray
	var text: Color = .black
	var baseBackground: Color = .white
	var baseForeground: Color = .white
	
}
