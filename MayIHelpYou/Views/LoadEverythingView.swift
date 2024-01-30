//
//  LoadingView.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 06/04/2023.
//

import SwiftUI
import AlertToast

struct LoadEverythingView: View {

	@AppStorage(fb.spokenName) var appStoreSpokenName: String = ""
	@AppStorage(fb.voiceName) var appStoreVoiceName: String = ""
	
	@EnvironmentObject private var dataManager:DataManager
	@EnvironmentObject private var colorManager:ColorManager
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.dismiss) var dismiss

	@State private var showingLoadingScreenMissingToast = false
	@State private var showingErrorMessageToast = false
	@State private var toastErrorMessage = ""
	
	@State private var loadingEverything = true
	@State private var logo:Image = Image(systemName: "arrow.down.circle")
	
	@State var libraryCode:String //must be passed in
	
	var body: some View {
		VStack(){
			VStack {
				//Colour.green
				Text("May I Help You ?")
					.foregroundColor(colorManager.current.baseForeground)
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding(.top,40)
				Text("Your Customer Service Coach")
					.foregroundColor(colorManager.current.baseForeground)
					.font(.title2)
					.fontWeight(.bold)
					.padding(.top,1)
				
				
			} //: VSTACK
			.frame(maxHeight: 200)
			.frame(maxWidth: .infinity)
			.ignoresSafeArea()
			.background(colorManager.current.redAmberGREEN)
			
			ZStack {

				
				Rectangle()
					.fill(Color.white)
					.frame(width: 200, height: 200)
					.aspectRatio(1.0, contentMode: .fit)
					.shadow(radius: 3)
				
				Text("Loading...")
					.foregroundColor(.black)
					.offset(y: -30)
					.if (!loadingEverything) { view in
						view.hidden()
					}
				
				ActivityIndicator(isAnimating: loadingEverything, foreColor: .black)

					self.logo
						.resizable()
						.imageScale(.large)
						.foregroundColor(.accentColor)
						.padding(4)
						.scaledToFit()
						.frame(width: 200, height: 200)
						.cornerRadius(9)
						.if (loadingEverything) { view in
							view.hidden()
						}
//				}
				Spacer()
			}
			.padding()

			//TODO: make this dynamic
			Text("Welcome to Customer Service Training")
				.fixedSize(horizontal: false, vertical: true)
				.multilineTextAlignment(.center)
				.padding()
				.frame(width: 300, height: 200)
				.background(Rectangle().fill(Color(UIColor.systemBackground)).shadow(radius: 3))
				.if (loadingEverything) { view in
					view.hidden()
				}
			
			HStack {
				Button( action: {
					dismiss()
				}){
					Text("Start")
						.font(.title2)
						.fontWeight(.medium)
						.padding(10)
						.padding([.leading,.trailing],15)
						.foregroundColor(loadingEverything ? .gray : colorManager.current.baseForeground)
						
				}
				//.disabled(loadingEverything) //if enabled then, on error, user never able to get to app
				.background(colorManager.current.buttonBlue) // If you have this
				.cornerRadius(16)
				.padding(.top,10)
				.padding(.trailing,10)

				
			}
			Spacer()
			
			
			
		} //:VSTACK
		.toast(isPresenting: $showingLoadingScreenMissingToast){
			AlertToast(type: .regular, title: "Library code cannot be found. Please contact your administrator.")
		}
		.toast(isPresenting: $showingErrorMessageToast){
			AlertToast(type: .regular, title: toastErrorMessage)
		}
		
		.task {

			loadingEverything = true
			
			
			if libraryCode.isEmpty {
				toastErrorMessage = "Error, Library code is empty (\(libraryCode)) cannot continue."
				showingErrorMessageToast = true
				return
			}
			
			toastErrorMessage = "reading DB. Library code is \(libraryCode)"
			Task {
				if let doc = await dataManager.downloadLibraryCodeDoc(code: libraryCode) {
					dump(doc)
					
					toastErrorMessage = "library code DB doc read company is \(doc.company) Library code is \(doc.code)"
					
					if libraryCode.isEmpty { //first load before login chat done -- should be removed after May 2023
						toastErrorMessage = "library code DB doc is empty"
						printhires("Loading... libraryCode is Empty so use default)")
						libraryCode = defaultLibraryCode //setting appStorage
					}
					
					printhires("Loading... \(libraryCode)")
					//Main app load data is here
					await dataManager.downloadEverthingAsync(libraryCode: libraryCode)
					let logo = dataManager.libraryCode.logo
					
					toastErrorMessage = "Everything downloaded.Code is \(libraryCode) company is \(doc.company) logo size \(logo.count)"
					
					//let image:Image = Image(data: logo) ??  Image(systemName: "arrow.down.circle")
					//TODO: could do with missing logo in bundle.
					self.logo =  Image(data: logo) ??  Image(systemName: "arrow.down.circle")
					
					if let uservars = await fsReadUserVariables(libraryCode) {
						let spokenName = uservars.spokenName.capitalizingFirstLetter()
						if spokenName.isEmpty { //problem
							if appStoreSpokenName.isNotEmpty {
								dataManager.spokenName = appStoreSpokenName.capitalizingFirstLetter()
								fbUpdateUserProperty(libraryCode, property: fb.spokenName, value: appStoreSpokenName.capitalizingFirstLetter())
							}
							
						}else{
							dataManager.spokenName = spokenName
							if appStoreSpokenName.isEmpty {
								appStoreSpokenName = spokenName
							}
						}
						
						if dataManager.voiceName.isEmpty {
							dataManager.voiceName = uservars.voiceMale ? GOOGLE_MALE_VOICE : GOOGLE_FEMALE_VOICE
							appStoreVoiceName = dataManager.voiceName
						}
						
						
					}else{ //nil == empty == no user record
						printhires("Load everything.task{} spoken name user row nil")
						if dataManager.spokenName.isEmpty && appStoreSpokenName.isNotEmpty {
							dataManager.spokenName = appStoreSpokenName
						}
					}
					
					
					
					
					loadingEverything = false
					
					//showingErrorMessageToast = true
					
				} else{
					toastErrorMessage = "Cannot read library code doc from DB"
					showingErrorMessageToast = true
					//showingLoadingScreenMissingToast = true
				}
				
				
			} //: local Task
			
			
		} //:TASK
		
	}

	struct ActivityIndicator: UIViewRepresentable {
		
		typealias UIView = UIActivityIndicatorView
		var isAnimating: Bool
		var foreColor: UIColor
		fileprivate var configuration = { (indicator: UIView) in }
		
		func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView {
			let v = UIView()
			v.color = foreColor
			return v
		}
		func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
			isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
			configuration(uiView)
		}
	}
}

struct LoadEverythingView_Previews: PreviewProvider {
	static var previews: some View {
		LoadEverythingView( libraryCode: "JA65")
			.environmentObject(ColorManager())
			.padding()
		
		LoadEverythingView( libraryCode: "DA65")
			.environmentObject(ColorManager())
			.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
			.preferredColorScheme(.dark)
			.padding()
	}
}
