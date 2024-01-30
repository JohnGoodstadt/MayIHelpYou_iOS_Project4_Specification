//
//  NotificationManager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 30/04/2023.
//

import Foundation
import NotificationCenter


func removePendingNotificationRequests(UIDs:[String]){
	
	UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:UIDs)
}
func setDailyNotification(hour:Int, minute:Int = 0)  {
	if let tomorrow = tomorrowMorning(hour: hour) {
		let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: tomorrow)
		
		let content = UNMutableNotificationContent()
		content.title = "Lessons still to do"
		content.subtitle = "Tap to continue."
		content.sound = UNNotificationSound.default
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		let request = UNNotificationRequest(identifier: lessonNotificationUID, content: content, trigger: trigger)
		
		//			UNUserNotificationCenter.current().add(request)
		UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
			if let error = error {
				printhires(error.localizedDescription)
			} else {
				//notification set up successfully
				printhires("Notification Set up OK")
				
				debugNotifications()
			}
		})
		
		
		
	}
	
}
func notificationAuthStatus() -> String {
	var status = "notDetermined"
	UNUserNotificationCenter.current().getNotificationSettings { settings in
		switch settings.authorizationStatus {
			case .authorized:
				status = "authorized"
			case .provisional:
				status = "provisional"
			case .notDetermined:
				status = "notDetermined"
			case .denied:
				status = "denied"
			case .ephemeral:
				status = "ephemeral"
			default:
				break
		} // End of "switch settings.authorizationStatus {"
	} // End of "{ settings in"
	return status
}
//https://onmyway133.com/posts/how-to-check-if-push-notification-is-actually-enabled-in-ios/
func isPushNotificationEnabled() -> Bool {
  guard let settings = UIApplication.shared.currentUserNotificationSettings
	else {
	  return false
  }

  return UIApplication.shared.isRegisteredForRemoteNotifications
	&& !settings.types.isEmpty
}
func debugNotifications(){
	var message = ""
	let center = UNUserNotificationCenter.current()
	center.getPendingNotificationRequests(completionHandler: { requests in
		message = "\(requests.count) request(s) pending."

		
		for request in requests {
			print(request)
			let _ = request.trigger
			let isProd = request.identifier == lessonNotificationUID
			if isProd {
				if let calendarNotificationTrigger = request.trigger as? UNCalendarNotificationTrigger,
					let nextTriggerDate = calendarNotificationTrigger.nextTriggerDate()  {
					print(nextTriggerDate)
					message = message + "next trigger date \(nextTriggerDate)"
				}
				
			}
		}
		
		print(message)
	})
}
func isNotificationAllreadySet() -> Bool {
	
	var returnValue = false
	
	UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
		
		for request in requests {
			let isProd = request.identifier == lessonNotificationUID
			if isProd {
				returnValue = true
				break
			}
		}
		
	})

	return returnValue
}
func isNotificationNotSet() -> Bool {
	!isNotificationAllreadySet()
}
func tomorrowMorning(hour:Int, minute:Int = 0) -> Date? {
	let now = Date()
	var tomorrowComponents = DateComponents()
	tomorrowComponents.day = 1
	let calendar = Calendar.current
	if let tomorrow = calendar.date(byAdding: tomorrowComponents, to: now) {
		let components: Set<Calendar.Component> = [.era, .year, .month, .day]
		var tomorrowValidTime = calendar.dateComponents(components, from: tomorrow)
		tomorrowValidTime.hour = hour
		tomorrowValidTime.minute = minute
		if let tomorrowMorning = calendar.date(from: tomorrowValidTime)  {
			return tomorrowMorning
		}

	}
	return nil
}
fileprivate func tomorrowMorning(hour:Int) -> Date? {
	let now = Date()
	var tomorrowComponents = DateComponents()
	tomorrowComponents.day = 1
	let calendar = Calendar.current
	if let tomorrow = calendar.date(byAdding: tomorrowComponents, to: now) {
		let components: Set<Calendar.Component> = [.era, .year, .month, .day]
		var tomorrowValidTime = calendar.dateComponents(components, from: tomorrow)
		tomorrowValidTime.hour = hour
		if let tomorrowMorning = calendar.date(from: tomorrowValidTime)  {
			return tomorrowMorning
		}

	}
	return nil
}
