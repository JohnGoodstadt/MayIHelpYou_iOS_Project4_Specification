//
//  NoNetworkView.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 19/04/2023.
//

import SwiftUI

struct NoNetworkView: View {
	@StateObject var networkMonitor = NetworkMonitor()
	@EnvironmentObject private var colorManager:ColorManager
	var body: some View {
		ZStack {
			
			VStack() {
				Text("No network detected")
				
					.padding()
					.fixedSize(horizontal: false, vertical: true)//for iPhone SE
					.foregroundColor(colorManager.current.text)
					.frame(maxWidth: .infinity)
					.multilineTextAlignment(.center)
					.background(colorManager.current.backgroundLightGrey)
					.cornerRadius(8)
					.padding()
					.padding(.top,50)
				Spacer()
				
				Image(systemName: "wifi.slash")
					.symbolRenderingMode(.palette)
					.foregroundColor(.red)
					.font(.system(size: 48))
				
				Spacer()
				Button(action: {
					if networkMonitor.isConnected == false {
						print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>")
						print("<<<<<<<<<<< Still No network >>>>>>>>>>>>>>>>")
						print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>")
					}
						
					//					}
				}) {
					Text("Try Again")
						.padding()
						.padding([.leading,.trailing], 20)
						.foregroundColor(colorManager.current.baseBackground)
						.background(colorManager.current.buttonBlue) // If you have this
						.cornerRadius(8)
					//						.padding(.bottom,5)
						.padding()
						.padding(.bottom,50)
					
				}
				
				
				
			}//: VSTACK
		}//: ZSTACK
		.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
		.background(LinearGradient(gradient: Gradient(colors: [colorManager.current.redAMBERGreen, colorManager.current.redAMBERGreen]), startPoint: .top, endPoint: .bottom))
		.cornerRadius(20)
		.padding(.horizontal, 10)
	}
}

struct NoNetworkView_Previews: PreviewProvider {
	static var previews: some View {
		NoNetworkView()
	}
}
