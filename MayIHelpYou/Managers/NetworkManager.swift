//
//  NetworkManager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 19/04/2023.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
	
//	@Published var isNetworkConnected = false // assume is not connected
	
	private let networkMonitor = NWPathMonitor()
	private let workerQueue = DispatchQueue(label: "Monitor")
	var isConnected = false

	init() {
		networkMonitor.pathUpdateHandler = { path in
			self.isConnected = path.status == .satisfied
			Task {
				await MainActor.run {
					self.objectWillChange.send()
				}
			}
		}
		networkMonitor.start(queue: workerQueue)
	}
}
