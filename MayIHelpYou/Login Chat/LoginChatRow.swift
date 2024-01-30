//
//
//  ChatRow.swift
//  WhatsappUI
//
//  Created by Haipp on 26.06.21.
//  
	

import SwiftUI


struct LoginChatRow: View {
	
	let chat: LoginChat
	
	var body: some View {
		HStack(spacing: 20) {
			Image(chat.avatar.imgString)
				.resizable()
				.frame(width: 70, height: 70)
				.clipShape(Circle())
			
			ZStack {
				VStack(alignment: .leading, spacing: 5) {
					HStack {
						Text(chat.avatar.name)
							.bold()
						Spacer()
						Text(chat.messages.last?.date.descriptiveString() ?? "")
							.foregroundColor(chat.hasUnreadMessage ? .red : .gray)
					}
					
					HStack {
						Text(chat.avatar.subTitle)
							.foregroundColor(.gray)
							.lineLimit(2)
							.frame(height: 50, alignment: .top)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.trailing, 40)
					}
				}
				
				Circle()
					.foregroundColor(chat.hasUnreadMessage ? .red : .clear)
					.frame(width: 18, height: 18)
					.frame(maxWidth: .infinity, alignment: .trailing)
			}
		}
		.frame(height: 80)
	}
}



struct LoginChatRow_Previews: PreviewProvider {
	
	static let chat = LoginChat(avatar: Avatar(name: "Lorenz",avatarArea: .loginFlow, subTitle: "", imgString: "img1", voice: "en-AU-News-G"),
								[LoginMessage("Hey flo, how are you?")])
	
	static var previews: some View {
		LoginChatRow(chat: chat)
			.padding(.horizontal)
	}
}
