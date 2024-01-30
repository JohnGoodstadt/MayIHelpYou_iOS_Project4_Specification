//
//  Date.swift
//  May I Help You?
//
//  Created by John goodstadt on 21/03/2023.
//

import Foundation
import SwiftUI

extension Date
{
	func relativeDateAsString() -> String
	{
		let dcf: DateComponentsFormatter = DateComponentsFormatter()
		dcf.includesApproximationPhrase = false
		dcf.includesTimeRemainingPhrase = false
		dcf.allowsFractionalUnits = false
//		dcf.collapseLargestUnit = true
		dcf.maximumUnitCount = 1
		dcf.unitsStyle = .abbreviated
		dcf.allowedUnits = [.second, .minute, .hour, .day, .month, .year]
		return dcf.string(from: self, to: Date()) ?? "NA"
	}

	func futureDate(years:Int) -> Date {
		let currentDate = self
		var dateComponent = DateComponents()
		dateComponent.year = years
		let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? self	
//		print(currentDate)
//		print(futureDate!)
		
		return futureDate
	}

}
