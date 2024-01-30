//
//  Created by Robert Petras
//  Credo Academy ♥ Design and Code
//  https://credo.academy
//Users/johngoodstadt/Docs/Development/Bridge/Fructus iOS 16/Fructus/App/BalancedView.swift/

import SwiftUI

struct PracticeCarouselView: View {
	// MARK: - PROPERTIES
	
	@EnvironmentObject var dataManager:DataManager
	

	@State var cards:[PracticeCard] = CardData
	
	// MARK: - BODY
	
	var body: some View {
		
		TabView {
			ForEach(cards,id: \.self) { card in
				PracticeCardView(card: card, displayCardTypes: false)
			} //: LOOP
		} //: TAB
		.tabViewStyle(PageTabViewStyle())
		.padding(.vertical, 20)
		.accentColor(.black)
		
	}
}

// MARK: - PREVIEW

//struct CardCarouselView_Previews: PreviewProvider {
//
//
////	@State static var card:Hand = DataManager().db[3]
//	@State static var filteredList = DataManager().db.prefix(3)
//
//
//	static var previews: some View {
//		CardCarouselView( filteredList: filteredList)
//			.environmentObject(DataManager())
//			.previewDevice("iPhone 13")
//	}
//}
