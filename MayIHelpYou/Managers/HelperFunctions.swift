//
//  HelperFunctions.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 27/04/2023.
//

import Foundation

public func printhires(_ message:String = ""){
	#if DEBUG
	print("============================================")
	print("=====> \(message)")
	print("============================================")
	#endif
}
