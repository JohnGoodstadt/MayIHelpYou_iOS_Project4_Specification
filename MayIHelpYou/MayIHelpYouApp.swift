//
//  MayIHelpYouApp.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 16/03/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		
		return true
	}
	func application(_ application: UIApplication,
					 didReceiveRemoteNotification notification: [AnyHashable : Any],
					 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

		print(notification)
		//needed for PhoneNumber Auth
		if Auth.auth().canHandleNotification(notification) {
			completionHandler(.noData)
			return
		}

	}
}

@main
struct MayIHelpYouApp: App {
	
	@AppStorage("isOnboarding") var isOnboarding: Bool = true
	@State var dataManager:DataManager = DataManager()
	@State var colorManager:ColorManager = ColorManager()
	
	// register app delegate for Firebase setup
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	init(){
		
		Task {
			if let currentUser = Auth.auth().currentUser {
				printhires("User Firebase UID is:\(currentUser.uid)")
			}else{
				printhires("User is Not Signed In")
			}
		}
	}
	
	var body: some Scene {
		WindowGroup {
			
			
			
			TabContentView()
				.environmentObject(dataManager)
				.environmentObject(colorManager)
				.onAppear{
					GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
						
						if error != nil || user == nil {
							printhires("TabContentView.onAppear().GIDSignIn Error \(error?.localizedDescription ?? "Unknown GIDSignIn error")")
						}else{
							printhires("TabContentView.onAppear().GIDSignIn GOOD \(user?.userID ?? "unknown user")")
						}
					}
				}
			
			
		}
	}
}
