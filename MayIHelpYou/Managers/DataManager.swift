//
//  DataMaAnager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 27/03/2023.
//

import Foundation
import Collections

@MainActor class DataManager: ObservableObject {
	
	@Published  var company:String
	@Published  var lessonCode:String
	@Published  var libraryCode:LibraryCode
	@Published  var phrases:[Phrase]
	@Published  var phraseCategories:[PhraseCategory]
	//@Published  var futureCategories:[FutureTabCategory]
	@Published  var lessons:[Lesson]
	@Published  var conversations:[Conversation] //TODO: May be remove this - chatQuestions replacement -- NOTE USED BY ADMIN
	@Published  var chatQuestions:[PracticeChat]
	@Published  var avatars:[Avatar]
	
	@Published  var spokenName:String = ""// from User table
	@Published  var voiceName:String = GOOGLE_FEMALE_VOICE
	
	init(_ isTestRun:Bool = false){
		
		
//		print("=================================================")
//		print("======== init() DataManager =====================")
//		print("=================================================")
		
		self.company = defaultCompanyName
		self.lessonCode = defaultLibraryCode
		
		guard !isTestRun else {
			phrases = StarterPhrases
			phraseCategories = StarterPhraseCategories
			//futureCategories = MinimalFutureTabs
			lessons = StarterLessons
			libraryCode = MinimalLibraryCode
			conversations = EmptyConversations
			chatQuestions = [PracticeChat]()//transformConversationsToChats(MinimalConversations)
			avatars = MinimalAvatars
			
			
			spokenName = "Alice"
			
			//https://stackoverflow.com/questions/34474545/self-used-before-all-stored-properties-are-initialized
			// end of initialization!
			// now we canchange chatQuestions
			chatQuestions = transformConversationsToChats(MinimalConversations)
			return
		}
		
		phrases = MinimalPhrases
		phraseCategories = MinimalPhraseCategories
		//futureCategories = MinimalFutureTabs
		lessons = MinimalLessons
		libraryCode = MinimalLibraryCode
		conversations = EmptyConversations
		chatQuestions = [PracticeChat]()//see above
		
		spokenName = "" //trigger for missing name
		avatars = MinimalAvatars

		chatQuestions = transformConversationsToChats(conversations)
	}
	
	func resetLessons(){
		
		self.phrases = self.phrases.map { ( p: Phrase) -> Phrase in
			p.playedCount = 0
			return p
		}
		
		self.lessons = self.lessons.map { lesson in
			let mlesson = lesson // parameter masking to allow local mutation
			//			mlesson.complete = false
			mlesson.lessonState = .notStarted
			return mlesson
		}
		
		self.phraseCategories = self.phraseCategories.map { phrase in
			var _ = phrase
			return phrase
		}
	}
	func resetChat(chatUID:UUID){
		
		if let idx = chatQuestions.firstIndex(where: { $0.id == chatUID }) {
			var mChat = chatQuestions[idx]
			mChat.resetState()
			
			chatQuestions[idx] = mChat
		}
	}
	func incChatAttempts(chatUID:UUID, attempts:Int){
		
		if let idx = chatQuestions.firstIndex(where: { $0.id == chatUID }) {
			var mChat = chatQuestions[idx]
			mChat.attempts = attempts
			
			chatQuestions[idx] = mChat
		}
	}
	//MARK: - DEBUG Routines
	func resetChats(){
		
		self.chatQuestions = self.chatQuestions.map { ( c: PracticeChat) -> PracticeChat in
			var mChat = c
			mChat.resetState()
			return mChat
		}
	}
	public func completeLesson(_ lessonNumber:Int = 1){
		
		if let lesson = self.lessons.first(where: { $0.lessonNumber == lessonNumber}) {
			lesson.complete = true
			lesson.lessonState = .postComplete
		}
		
	}
	func conversationByNumber(_ conversationNumber:Int) -> [Conversation] {
		self.conversations.filter({ $0.conversationNumber == conversationNumber })
	}
	var conversationNumbers: [Int] {
		
		let result = Dictionary(grouping: self.conversations, by: { $0.conversationNumber })
		
		//dump(result.keys)
		
		var a:[Int] = [Int]()
		
		result.keys.forEach{
			a.append($0)
		}
		
		//print(a)
	
		
		return a.sorted()
		
	}
	var areSomeLessonsStarted:Bool {
		
		if let _ = lessons.firstIndex(where: { $0.lessonState == .started || $0.lessonState == .waiting }) {
			return true
		}else{
			//1 extra check
			//if any complete but some not yet started then can remind
			if let _ = lessons.firstIndex(where: {
				($0.lessonState == .complete || $0.lessonState == .postComplete) &&
				($0.lessonState == .notStarted)
			}) {
				return true
			}else{
				return false
			}
		}
	}
	func calcPercentageCompleteObsolete(_ lessonNumber:Int) -> CGFloat {
		
		guard lessonNumber <= lessons.count else { return 0.0 }
		
		return 0.0

		
	}
	func calcCompletions() -> [Bool]{
		
		
		//var returnValue8: [Bool] = Array(repeating: false, count: lessonTabs.count)
		var returnValue: [Bool] = [Bool](repeating: false, count: lessons.count)
		
		for (index, element) in lessons.enumerated() {
			if element.lessonState == .complete || element.lessonState == .postComplete {
				returnValue[index] = true
			}
			if false && element.complete {
				returnValue[index] = true
			}
		}
		
		return returnValue
	}
	
	func setLessonComplete(_ lessonIndex:Int) {
		//TODO: remove this
		self.lessons[lessonIndex-1].complete = true
	}
	
	func updateLibraryCode(_ code:String) {
		
		self.lessonCode = code
//		var lc = self.libraryCode
//		lc.code = code
		
		self.libraryCode.code = code
		
	}
	
	func updateApp(libraryCode:LibraryCode,phrases:[Phrase],
				   phraseCategories:[PhraseCategory],
				   lessons:[Lesson],
				   lessonStatesForUser:[LessonStateForUser],
				   phraseStatistic:[PhraseStatistic] = [PhraseStatistic](),
				   conversations:[Conversation] = [Conversation](),
				   chatStatesForUser:[ChatStateForUser] = [ChatStateForUser](),
				   avatars:[Avatar] = [Avatar]())
	{
		
		print("dataManager.updateApp()")
		print("incoming code:\(libraryCode.code)")
		print("incoming lessons:\(lessons.count)")
		print("incoming phrases:\(phrases.count)")
		print("current  phrases:\(self.phrases.count)")
		
		self.libraryCode = libraryCode
		self.lessonCode = libraryCode.code
		
		self.phraseCategories = phraseCategories
		self.lessons = lessons
		self.phrases = phrases
		self.conversations = conversations.sorted(by: { $0.conversationNumber < $1.conversationNumber && $0.sortNumber < $1.sortNumber })

		self.avatars = avatars
		
		//print("\(self.avatars.count) \(avatars.count)")
	
		
		if let avatar = avatars.first(where: {$0.area == .help}) {
			printhires("\(avatar)")
		}else{
			printhires("Error on avatar filter - help area")
		}
		
		
		//new chats format
//		let sortedConversations
		self.chatQuestions = transformConversationsToChats(conversations)
		
		print("updateApp.conversations State:\(self.conversations.count)")
//
		//self.conversations.sorted(by: { $0.sortNumber < $1.sortNumber }).forEach{
		self.conversations.forEach{
			print("\($0.id), cn:\($0.conversationNumber), sn:\($0.sortNumber),prompt:\($0.prompt.prefix(32)) ")
		}
		
		
		//update the played stat of the phrase
		if !phraseStatistic.isEmpty {
			let mutatedPhrases = phrases.map { phrase in
				if let found = phraseStatistic.first(where: {$0.id == phrase.id}) {
					phrase.playedCount = found.playedCount
				}
				
				return phrase
			}
			
			self.phrases = mutatedPhrases
		}
		
		//:LESSON STATE
		
		//update the saved state of lessons
		//for each lesson find user state and assign
		if !lessonStatesForUser.isEmpty {
			let mutatedLessons = lessons.map { lesson in
				let lesson = lesson // parameter masking to allow local mutation
				if let found = lessonStatesForUser.first(where: {$0.id == lesson.id}) {
					//				lesson.complete = found.complete
					lesson.playCycle = found.playCycle
					//				lesson.waiting = found.waiting
					lesson.waitTimeTarget = found.waitTimeTarget
					lesson.lessonState = found.lessonState
				}
				
				return lesson
			}
			
			self.lessons = mutatedLessons
		}
		
		//Now update the state of the users progress
		print("\(lessonStatesForUser.count)")
		guard !lessonStatesForUser.isEmpty && lessonStatesForUser.count == lessonStatesForUser.count else {
			print("===> Invalid or empty lessonState for user. Does not match lessonTabs.count. ===>")
			return
		}
		
		//:CHAT STATE
		if !chatStatesForUser.isEmpty {
			let mutatedChatQuestions = chatQuestions.map { chat in
				var chat = chat // parameter masking to allow local mutation
				if let found = chatStatesForUser.first(where: {$0.conversationNumber == chat.conversationNumber}) {
					let currentQuestionNumber = found.currentQuestionNumber
					
					chat.currentQuestionNumber = currentQuestionNumber
					chat.completed = found.completed
					chat.attempts = found.attempts
					
					if !chat.completed && chat.currentQuestionNumber > 1 { //past first chat - prefill messages
						chat.rollForwardToQuestion(currentQuestionNumber)
					}
				}
				
				return chat
			}
			
			self.chatQuestions = mutatedChatQuestions
		}

		
	}
#if DONT_COMPILE
	func updateAppMoved(libraryCode:LibraryCode,phrases:[Phrase],phraseCategories:[PhraseCategory],lessonTabs:[Lesson]){
		
		
		print("dataManager.updateApp()")
		print("incoming phrases:\(phrases.count)")
		print("current  phrases:\(self.phrases.count)")
		
		self.libraryCode = libraryCode
		self.phrases = phrases
		self.phraseCategories = phraseCategories
		self.lessons = lessonTabs
		
		//Now update the state of the users progress
		
		print("\(lessonStatistics.count)")
		guard !lessonStatistics.isEmpty && lessonStatistics.count == lessons.count else {
			print("Invalid lessonStatistics. Does not match lessonTabs.count")
			return
		}
		//update the saved state of lessons
		let mutatedLessonTabs = lessons.map { lesson in
			var lesson = lesson // parameter masking to allow local mutation
			if let found = lessonStatistics.first(where: {$0.id == lesson.id}) {
				//lesson.complete = found.complete
				lesson.playCycle = found.playCycle
				//lesson.waiting = found.waiting
				lesson.waitTimeTarget = found.waitTimeTarget
			}
			
			return lesson
		}
		
		self.lessons = mutatedLessonTabs
		
	}
#endif
	
	var viewableLessonsPerPhrase : String {
		String(libraryCode.lessonsPerPhrase)
	}
	var viewableTimeBetweenLessons : String {
		
		var returnString = ""
		
		let timeInMinutes =  libraryCode.timeBetweenLessons > 0 ? libraryCode.timeBetweenLessons : 1 //1 and above (1 is minimum
		
		if timeInMinutes <= 60 {
			
			returnString = timeInMinutes == 1 ? "1 minute" : "\(timeInMinutes) minutes"
		}else{
			let timeInHours = timeInMinutes / 60 //assumes multiple of hours
			returnString = timeInHours == 1 ? "1 hour" : "\(timeInHours) hours"
		}
		
		
		return returnString
	}
	func downloadEverthing(libraryCode:String = defaultLibraryCode) {
		Task {
			await downloadEverthingAsync()
		}
	}
	func downloadEverthingAsync(libraryCode:String = defaultLibraryCode) async {
		
		let result = await downloadEverything(code: libraryCode)
		
		switch result {
			case .success(let everything):
				print("success getting everything fom fb")
				
				let fbLibraryCode = everything[fb.code]
				let fbphraseCategories = everything[fb.phraseCategories]
				let fblessons = everything[fb.lessons]
				let fbphrases = everything[fb.phrases]
				let fblessonState = everything[fb.lessonState]
				let fbphraseStatistic = everything[fb.phraseStatistic]
				let fbconversations = everything[fb.conversations]
				let fbchatState = everything[fb.chatState]
				let fbavatars = everything[fb.avatars]
				
				guard fbphrases is [Phrase],
						fblessons is [Lesson],
						fbphraseCategories is [PhraseCategory],
						fbLibraryCode is [LibraryCode],
						fblessonState is [LessonStateForUser],
						fbphraseStatistic is [PhraseStatistic],
						fbconversations is [Conversation],
						fbchatState is [ChatStateForUser],
						fbavatars is [Avatar]
				else {
					
					print("Error getting data in downloadEverthingAsync() invalid Type")
					return
				}
				
				
				
				guard let libraryCode = fbLibraryCode as?  [LibraryCode] else { return }
				guard let phrases = fbphrases as?  [Phrase] else { return }
				guard let phraseCategories = fbphraseCategories as?  [PhraseCategory] else { return }
				guard var lessons = fblessons as?  [Lesson] else { return }
				guard let lessonState = fblessonState as?  [LessonStateForUser] else { return }
				guard let phraseStatistic = fbphraseStatistic as?  [PhraseStatistic] else { return }
				guard let conversations = fbconversations as?  [Conversation] else { return }
				guard let chatState = fbchatState as?  [ChatStateForUser] else { return }
				guard let avatars = fbavatars as?  [Avatar] else { return }
				
				
				let lessonsValidToday = removeNotStartedLessons(lessons)
				if lessonsValidToday.count != lessons.count {
					print("original lesson count:\(lessons.count)")
					print("lessons (some not valid today):\(lessonsValidToday.count)")
					lessons = lessonsValidToday
				}
				
				//Final data
				print("phrases:\(phrases.count)")
				print("phraseCategories:\(phraseCategories.count)")
				print("lessons:\(lessons.count)")
//				print("lessons (some removed):\(lessons.count)")
				print("lessonState:\(lessonState.count)")
				print("phraseStatistic:\(phraseStatistic.count)")
				print("conversations:\(conversations.count)")
				print("chats:\(chatState.count)")
				print("avatars:\(avatars.count)")
				
				
				dump(avatars)
				
				
				
				
				
				
				//TODO: get actual conversation questions
				//hard code for 2 just now May 2023
				
				
				
				
				//				phrases.forEach{
				//					print("phrase:\($0.id), categoryNumber:\($0.categoryNumber) phrase:\($0.phrase.prefix(10))")
				//				}
				//
				//				lessonState.forEach{
				//					print("lesson:\($0.id), playCycle:\($0.playCycle) state:\($0.lessonState)")
				//				}
				
				//				lessonState.forEach{
				//					print("lesson:\($0.id), playCycle:\($0.playCycle) state:\($0.lessonState)")
				//				}
				
				if let libraryCode = libraryCode.first {
					updateApp(libraryCode:libraryCode,
							  phrases:  phrases,
							  phraseCategories: phraseCategories,
							  lessons: lessons,
							  lessonStatesForUser: lessonState,
							  phraseStatistic:phraseStatistic,
							  conversations: conversations,
							  chatStatesForUser: chatState,
							  avatars: avatars
					)
					//grab a few single items to store for later
					postLoadDownload()
					
					
					
				}
				
				
			case .failure(let error):
				print(error.localizedDescription) // Prints the error message
		}
	}
	func downloadLibraryCodeDoc(code:String) async  -> LibraryCode? {
		
		return await fsDownloadLibraryCodeDoc(code: code)

	}
	func postLoadDownload() {
		//App will work even if this does not
		Task {
//			if let date = await readUserDateProperty(libraryCode.code, property: fb.lessonReminderTime) {
//				self.libraryCode.lessonReminderTime = date
//			}else{
//				self.libraryCode.lessonReminderTime =  Date(timeIntervalSince1970: 0) //min date
//			}
			
			if let rc = await read2UserProperties(libraryCode.code, property1: fb.lessonReminderTime, property2: fb.lessonReminderOn) {
				self.libraryCode.lessonReminderTime = rc.time
				self.libraryCode.lessonReminderOn = rc.On
			}else{
				self.libraryCode.lessonReminderTime =  Date(timeIntervalSince1970: 0) //min date
				self.libraryCode.lessonReminderOn = true
			}
			
		}
		
	}
	//The base read only common lessons for any user
	//TODO: dataManager.downloadEverything() be used here?
	func downloadStaticLessonDataAsync(code:String = defaultLibraryCode) async {
		//TODO: CODE??
		let result = await downloadStaticLessonData( company: defaultCompanyName, code: code)
		
		switch result {
			case .success(let everything):
				print("success getting everything")
				
				let fbLibraryCode = everything[fb.code]
				let fbphraseCategories = everything[fb.phraseCategories]
				let fblessonTabs = everything[fb.lessons]
				let fbphrases = everything[fb.phrases]
				
				guard fbphrases is [Phrase], fblessonTabs is [Lesson], fbphraseCategories is [Lesson], fbLibraryCode is [LibraryCode]/*, fbstatistics is [LessonStatistics]*/ else{
					print("Error getting data in downloadEverthingAsync()")
					return
				}
				
				
				
				guard let libraryCode = fbLibraryCode as?  [LibraryCode], libraryCode.count == 1 else { return }
				guard let phrases = fbphrases as?  [Phrase] else { return }
				guard let phraseCategories = fbphraseCategories as?  [PhraseCategory] else { return }
				guard let lessonTabs = fblessonTabs as?  [Lesson] else { return }
				
				print("phrases:\(phrases.count)")
				print("phraseCategories:\(phraseCategories.count)")
				print("lessonTabs:\(lessonTabs.count)")
				
				if let lc = libraryCode.first {
					updateApp(libraryCode:lc, phrases:  phrases, phraseCategories: phraseCategories, lessons: lessons, lessonStatesForUser: [LessonStateForUser]())
				}
				
				
			case .failure(let error):
				print(error.localizedDescription) // Prints the error message
		}
	}
	func createUserPhraseStatisticIfNecessaey(phraseUID:String){
		//TODO: could check playedCount to guess already created
		
		
		Task {
			let exists = await doesUserPhraseStatisticExist(code: libraryCode.code, phraseUID)
			if !exists {
				createUserPhraseStatistic(libraryCode.code, phraseUID)
			}
		}
		
	}
	func updatePlayCycleForLesson(_ lessonNumber:Int,playCycle:Int) {
		
		print("updatePlayCycleForLesson() ")
		if let found = lessons.first(where: {$0.id == lessonNumber}) {
			found.playCycle = playCycle
			print("updatePlayCycleForLesson() found.playCycle \(found.playCycle) \(found.id)")
			
		}
		
	}
	func updateLessonState(_ code:String) {
		
		
		
		var stats = [LessonStateForUser]()
		self.lessons.forEach {
			let lessonState = LessonStateForUser(id: $0.id)
			lessonState.playCycle = $0.playCycle
			//lessonState.waiting = $0.waiting
			lessonState.waitTimeTarget = $0.waitTimeTarget
			//lessonState.complete = $0.complete
			lessonState.lessonState = $0.lessonState
			
			stats.append(lessonState)
		}
		
		fbUploadLessonState(code: code, stats)
		
	}
	func choosePhrasesInLesson(_ lessonNumber:Int) -> [Phrase] {
		
		//		print("-----------------------------")
		//
		//		let p = phrases.filter({$0.lessonNumber == lessonNumber})
		//
		//		print("choosePhrasesInLesson() lessonNumber \(lessonNumber) phrase count:\(p.count)")
		//		print("-----------------------------")
		
		
		return phrases.filter({$0.lessonNumber == lessonNumber})
	}
	func chooseConversationDEBUG(_ conversationNumber:Int) -> Conversation {
		_ = conversations.first(where: {$0.conversationNumber == conversationNumber})
		return  conversations.first(where: {$0.conversationNumber == conversationNumber})!
	}
	func chooseConversationInConversations(_ conversationNumber:Int) -> [Conversation] {
		_ = conversations.filter({$0.conversationNumber == conversationNumber})
		return conversations.filter({$0.conversationNumber == conversationNumber})
	}
	//MARK: - Moved here from ContentView.ViewModel
	func lessonTitle(_ lessonNumber:Int) -> String {
		guard lessonNumber <= lessons.count else { return "Unknown" }
		
		return lessons[lessonNumber-1].title
	}
	func canIGo(_ lessonNumber:Int) -> Bool {
		guard lessonNumber <= lessons.count else { return true }
		
		return lessons[lessonNumber-1].waitTimeTarget < Date() ? true : false
	}
	func amIWaiting(_ lessonNumber:Int) -> Bool {
		guard lessonNumber <= lessons.count else { return false }
		
		return lessons[lessonNumber-1].waiting
	}
	func viewableWaitTime(_ lessonNumber:Int) -> String {
		guard lessonNumber <= lessons.count else { return "Unknown" }
		
		if lessons[lessonNumber-1].waiting {
			return currentRelativeWaitTime(lessonNumber)
		}else{
			return ""
		}
	}
	private func currentRelativeWaitTime(_ lessonNumber:Int) -> String {
		guard lessonNumber <= lessons.count else { return "" }
		
		let waitTimeTarget = lessons[lessonNumber-1].waitTimeTarget
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .full
		
		return formatter.localizedString(for: waitTimeTarget, relativeTo: Date.now)
		
	}
	func resetAnyWaitingLessons() {
		
		for index in 0..<lessons.count {
			let lesson = lessons[index]
			if lesson.waiting && lesson.waitTimeTarget < Date() {
				lessons[index].waiting = false //NOTE I need this format to actually update the flag
			}
		}
	}
	//TODO: Maybe redundant April 2023
	private func incPlayCycleIfNecessary(_ phrase:Phrase,_ lessonNumber:Int){
		guard lessonNumber <= lessons.count else { return }
		
		//1. For all phrases in the lesson get played count -- NOTE: previous rule: playCount only ever 1 distance apart
		//2. We are in playCycle of the minimum - set if different
		
		
		let minimumPlayedCount = choosePhrasesInLesson(phrase.lessonNumber).map { $0.playedCount }.min()
		guard let minimumPlayedCount else { return }
		
		//previous rule playCount only ever 1 distance apart
		let currentLesson = lessons[lessonNumber-1]
		if minimumPlayedCount > currentLesson.playCycle {
			lessons[lessonNumber-1].playCycle = currentLesson.playCycle + 1
			print("=====> INCREMENTING CYCLE now at \(lessons[lessonNumber-1].playCycle)")

		}
		
#if DONT_COMPILE
		if found.isEmpty {
			print("incPlayCycleIfNecessary() can increment play Cycle")
			let min = choosePhrasesInLesson(phrase.lessonNumber).map { $0.playedCount }.min()
			guard let min else { return }
			
			//previous rule playCount only ever 1 distance apart
			let currentLesson = lessonsTabs[selectedLessonNumber-1]
			if min > currentLesson.playCycle {
				print("=====> INCREMENTING CYCLE \(min) =======>")
				lessonsTabs[selectedLessonNumber-1].playCycle = min
			}
			
		}else{
			print("incPlayCycleIfNecessary() can NOT increment play Cycle -- completed cycles is \(lessonsTabs[selectedLessonNumber-1].playCycle)")
		}
#endif
		
	}
	//TODO: remove this
	func lessonCompleted(_ lessonNumber:Int) -> Bool {
		guard lessonNumber <= lessons.count && lessonNumber > 0 else { return false }
		
		let c = lessons[lessonNumber-1].complete
		print("dataManager lesson \(lessonNumber) \(c ? "complete" : "not complete" )")
		
		return lessons[lessonNumber-1].complete
	}
	func lessonNotYetCompleted(_ lessonNumber:Int) -> Bool {
		!lessonCompleted(lessonNumber)
	}
	func percentageOfLessonPlayCyclesCompleted(_ lessonNumber:Int) -> CGFloat {
		guard lessonNumber <= lessons.count && lessonNumber > 0 else { return CGFloat(0) }
		
		//return CGFloat(0) //TODO: function not working
		//#if DONT_COMPILE
		let currentPlayCycle = lessons[lessonNumber-1].playCycle
		
		guard currentPlayCycle <= TARGET_AUDIO_COUNT else {
			return CGFloat(0)
		}
		
		let percent:Float = Float(currentPlayCycle) / Float(TARGET_AUDIO_COUNT)
		
		return CGFloat(percent)
		//#endif
	}
	func incPlayedCount(_ phraseUID:String) {
		if let idx = phrases.firstIndex(where: { $0.id == phraseUID }) {
			let phrase = phrases[idx]
			phrase.playedCount += 1
		}
	}
	func getPhrase(with UID:String) -> Phrase? {
		if let idx = phrases.firstIndex(where: { $0.id == UID }) {
			return phrases[idx]
		}
		
		return nil
	}
	func choosePhrases(_ categoryNumber:Int) -> [Phrase]{
		//print("choosePhrases \(categoryNumber)")
		let _ = phrases.filter({$0.categoryNumber == categoryNumber})
		//print(p.count)
		
		return phrases.filter({$0.categoryNumber == categoryNumber})
	}
	func phraseAdditional(_ selectedIndex:Int) -> String {
		
		guard selectedIndex < phraseCategories.count else {
			return ""
		}
		
		return phraseCategories[selectedIndex].additional
	}
	func phraseCategoryLinkTitleObsolete(_ selectedIndex:Int) -> String {
		guard selectedIndex < phraseCategories.count else {
			return ""
		}
		
		return phraseCategories[selectedIndex].linkTitle
	}
	func phraseCategoryLink(_ selectedIndex:Int) -> Link {
		guard selectedIndex < phraseCategories.count else {
			return Link(title: "", link: "")
		}
		
		//return Link(title: phraseCategories[selectedIndex].linkTitle, link: phraseCategories[selectedIndex].linkLink)
		
		return phraseCategories[selectedIndex].link
	}
	func debugLesson(_ lessonNumber:Int) {
		
		let p =   phrases.filter({$0.lessonNumber == lessonNumber})
		print("lesson \(lessonNumber) count is \(p.count)")
		
		
		
	}
	
	func mainTabs() -> [String] {
//		[libraryCode.lessonTabTitle,libraryCode.phrasesTabTitle,libraryCode.practiceTabTitle,"Future","P2","P3"]
		[libraryCode.lessonTabTitle,libraryCode.phrasesTabTitle,libraryCode.practiceTabTitle,"Future"]
	}
	func practiceCount() -> Int {
		conversations.map { $0.conversationNumber}.max() ?? 1
	}
	func chatCount() -> Int {
		2 //for now - April 2023
	}
	func canIPlayThisPhrase(_ phrase:Phrase,_ lessonNumber:Int) -> Bool {
		
		return true
		
	}

}
//MARK: - Practice Chats - message handling
extension DataManager {
	func sendMessage(_ text: String, in chat: PracticeChat, rowType: ChatMessage.RowType = .unknown) -> ChatMessage? {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			
			print("DataManager:Added to sendMessage: current count:\(chatQuestions[index].messages.count) chat index is:\(index)")
			

			
			if rowType == .unknown {
				let message = ChatMessage(text, type: .Received)
				chatQuestions[index].messages.append(message) //this should trigger refresh
				return message
			}else{
				let message = ChatMessage(text, type: .Received, rowType:rowType)
				chatQuestions[index].messages.append(message) //this should trigger refresh
				return message
			}
			
			
		}
		return nil
	}
	func sendMessage(_ message: ChatMessage, in chat: PracticeChat) {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			print("DataManager:Added to sendMessage: current count:\(chatQuestions[index].messages.count) chat index is:\(index)")
			chatQuestions[index].messages.append(message) //this should trigger refresh
		}
		
	}
	func totalQuestionCount(for chat: PracticeChat) -> Int {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			return chatQuestions[index].avatar.questionCount
		}
		
		return 1
	}
	func moveToCorrectAnswer(for chat: PracticeChat) -> UUID {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			
			let bucket = chat.messageQ.filter{ $0.questionNumber == chat.currentQuestionNumber && $0.bucketType == .postCorrect}
			
			if chat.currentQuestionNumber >= chat.avatar.questionCount {
				var c = chatQuestions[index]
				c.completed = true
				c.messages.append(contentsOf: bucket)
				print(c)
				chatQuestions[index] = c
			}else{
				chatQuestions[index].messages.append(contentsOf: bucket)
			}
			
			//create doc first time
			if chat.currentQuestionNumber == 1 {
				let chatStateForUser = ChatStateForUser(conversationNumber:chat.conversationNumber,currentQuestionNumber:chat.currentQuestionNumber,completed:false)
				fbUploadChatState(code: libraryCode.code, chatStateForUser)
			}else{
				fbUpdateUserPracticeStatProperty(code: libraryCode.code, chatID: chat.conversationNumber, property: fb.currentQuestionNumber, value: chat.currentQuestionNumber)
			}
			
			
			
			return chatQuestions[index].messages.last?.id ?? UUID()
		}
		
		return UUID() //should not happen
	}
	func moveToWrong1Answer(for chat: PracticeChat)  -> UUID {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			
			let originalBucket = chat.messageQ.filter{ $0.questionNumber == chat.currentQuestionNumber && $0.bucketType == .postWrong1}
			
//			chatQuestions[index].messages.forEach{
////				let uid:String = String($0.id.description)
//				print("\($0.id.description.prefix(4)) \($0.sortNumber) \($0.text)")
//			}
			//Copy to new message UUID for uniqueness
			var bucket = [ChatMessage]()
			originalBucket.forEach{
				print("\($0.id.description.prefix(4)) \($0.text)")
				let message = ChatMessage($0.questionNumber,$0.text,$0.rowType, $0.bucketType)
				bucket.append(message)
			}
			
			//force update ?
			var c = chatQuestions[index]
			c.messages.append(contentsOf: bucket)
			print(c)
			chatQuestions[index] = c
			
			return chatQuestions[index].messages.last?.id ?? UUID()
			
		}
		return UUID() //should not happen
	}
	func moveToWrong2Answer(for chat: PracticeChat)  -> UUID {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			
			let originalBucket = chat.messageQ.filter{ $0.questionNumber == chat.currentQuestionNumber && $0.bucketType == .postWrong2}
			
			
//			chatQuestions[index].messages.forEach{
//				print("\($0.id.description.prefix(4)) \($0.sortNumber) \($0.text)")
//			}
	
			//Copy to new message UUID for uniqueness
			var bucket = [ChatMessage]()
			originalBucket.forEach{
				//print("\($0.id.description.prefix(4)) \($0.sortNumber) \($0.text)")
				let message = ChatMessage($0.questionNumber,$0.text,$0.rowType, $0.bucketType)
				bucket.append(message)
			}
			//force update ?
			var c = chatQuestions[index]
			c.messages.append(contentsOf: bucket)
			print(c)
			chatQuestions[index] = c
			
			return chatQuestions[index].messages.last?.id ?? UUID()
			
		}
		return UUID() //should not happen
	}
	func wrong1Explanation(for chat: PracticeChat) -> String {
		if let message = chat.messageQ.first(where: { $0.questionNumber == chat.currentQuestionNumber && $0.rowType == .incorrect1Explanation }) {
			return message.text
		}else{
			return ""
		}
	}
	func wrong2Explanation(for chat: PracticeChat) -> String {
		if let message = chat.messageQ.first(where: {  $0.questionNumber == chat.currentQuestionNumber && $0.rowType == .incorrect2Explanation }) {
			return message.text
		}else{
			return ""
		}
	}
	func moveToLastCorrectAnswerObsolete(for chat: PracticeChat) {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			
			let bucket = chat.messageQ.filter{ $0.questionNumber == chat.currentQuestionNumber && $0.bucketType == .completed}
			
			chatQuestions[index].messages.append(contentsOf: bucket)
		}
		
	}
	//func moveToNextQuestion(for chat: Chat, nextQuestionNumber:Int = 1)  -> UUID{
	func moveToNextQuestion(for chat: PracticeChat)  -> UUID{
		
		let _ = chat.currentQuestionNumber
		
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			let nqn = chat.currentQuestionNumber + 1
			var bucket = chat.messageQ.filter{ $0.questionNumber == nqn && $0.bucketType == .question}
			
			//var replacedBucket = bucket//.map{ $0.text = replacePlaceholders($0.text) }
			
			for (index, _) in bucket.enumerated() {
			  //print("Item \(index): \(element)")
				bucket[index].text = replacePlaceholders(bucket[index].text)
			}
			

			
			var c = chatQuestions[index]
			c.currentQuestionNumber = nqn
			c.messages.append(contentsOf: bucket)
			print(c)
			chatQuestions[index] = c
			
			
			#if DONT_COMPILE
				var messageIDToScroll:UUID
				if let lastQuestionMessage = bucket.last(where: { $0.rowType == .prompt }) {
					//not scrolling far enough
					messageIDToScroll = lastQuestionMessage.id //on small phones missing top of prompt when going to absolute bottom
				}else{
					messageIDToScroll = chatQuestions[index].messages.last?.id ?? UUID()
				}
			
			#endif
			return chatQuestions[index].messages.last?.id ?? UUID()
		}
		
		return  UUID()
	}
//	func lastPromptID(for chat: Chat)  -> UUID{
//		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
//			//chat.incQuestionNumber()
////			let bucket = chat.messageQ.filter{ $0.questionNumber == nextQuestionNumber && $0.bucketType == .question}
////
////			var c = chatQuestions[index]
////			c.currentQuestionNumber = nextQuestionNumber
////			c.messages.append(contentsOf: bucket)
////			print(c)
////			chatQuestions[index] = c
//
//			return chatQuestions[index].messages.last?.id ?? UUID()
//		}
//
//		return  UUID()
//	}
	func getExplanation(for chat: PracticeChat, questionNumber:Int, rowType: ChatMessage.RowType = .correct) -> String {
		
		let explanationMessage = chat.messages.filter ({ $0.questionNumber == questionNumber}).first(where: { $0.rowType == rowType })
		
		return explanationMessage?.text ?? ""
	}
	func markAsUnread(_ newValue: Bool, chat: PracticeChat) {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			chatQuestions[index].hasUnreadMessage = newValue
		}
	}

	func markAsComplete(_ questionNumber: Int, chat: PracticeChat) {
		if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			if chatQuestions.indexExists(questionNumber) {//i.e. next index
				chatQuestions[index].currentQuestionNumber = questionNumber + 1
			}else{
				print("===> TOTAL CHAT HAS BEEN COMPLETED <===")
			}
		}
	}
	//so on "Carry On?" button no other button reacts
	func currentQuestionComplete(_ complete: Bool, chat: PracticeChat) {
		//if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
			if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
				chatQuestions[index].completedCurrentQuestion = complete
			}
		//}
	}
	func currentQuestionPrompt(for chat:PracticeChat, questionNumber:Int) -> String {
		
		print( chat.currentQuestionNumber)
		
		let prompt = chat.messageQ.filter ({ $0.questionNumber == questionNumber}).first(where: { $0.rowType == .prompt })
		
		return replacePlaceholders(prompt?.text ?? "")
	}

	func replacePlaceholderMessagesWithSpokenNameObsolete(){
		
		for chat in chatQuestions {
		
			for message in chat.messageQ {
				if message.rowType == .prompt || message.rowType == .correct { //only spoken texts
					
					if message.text.contains(placeholder.spokenname) {
						
						
						if let index = chatQuestions.firstIndex(where: { $0.id == chat.id }) {
							var mChat = chatQuestions[index]
							
							if let index2 = mChat.messageQ.firstIndex(where: { $0.id == message.id }) {
								let replacedText = replacePlaceholders(mChat.messageQ[index2].text)
								mChat.messageQ[index2].text = replacedText
//								var mMessage =  mChat.messageQ[index2]
//								mMessage.text = replacePlaceholders(mMessage.text)
								print(replacedText)
							}
							
							
						}
						

					}
					
				}
				
			}
			
		}
		
	}
	fileprivate func replacePlaceholders(_ text: String) -> String {
		
		if text.contains(placeholder.spokenname) {
			return text.replacingOccurrences(of: placeholder.spokenname, with: spokenName)
		}
		
		return text
	}
	func moveToNextQuestion(chat: PracticeChat) {
		
		
		
	}

	func getFilteredChats(query: String) -> [PracticeChat] {
		#if DONT_COMPILE
		let sortedChats = chatQuestions.sorted {
			///CHat doe snot have messages
			guard let date1 = $0.messages.last?.date else { return false }
			guard let date2 = $1.messages.last?.date else { return false }
			return date1 > date2
		}
		
		#endif
		//TODO: sort here needed
		return self.chatQuestions

	}
	

	
	func getSectionMessages(for chat: PracticeChat) -> [[ChatMessage]] {
		var res = [[ChatMessage]]()
		var tmp = [ChatMessage]()
		
//		print("dataManager.getSectionMessages() qn:\(currentQuestionNumber) messages:\(chat.messages.count)")
	//	print("---------")
		for message in chat.messages {
				if let firstMessage = tmp.first {
					let daysBetween = message.questionNumber - firstMessage.questionNumber
					//print("\(message.questionNumber) \(firstMessage.questionNumber) - is \(daysBetween)")
					if daysBetween >= 1 {
						res.append(tmp)
						tmp.removeAll()
						tmp.append(message)
					} else {
						tmp.append(message)
					}
				} else {
					tmp.append(message)
				}
			}
			res.append(tmp)
		
		//print("res  messages:\(res.count)")
		return res
	}
	func generateSuggestions() -> (lesson:Lesson?,chat:PracticeChat?,phrase:Phrase?){
		/*
		 3 Buttons (only 2 if all lessons completed).
		 
		 BUTTON:
		 1. Find started Lesson. Then act
		 if none
		 Find not started lessons. Then act
		 if none then all lessons completed dont do any lesson suggestions
		 
		 BUTTON:
		 Practice already done - try again? then act
		 if none suggest new practice then act

		 BUTTON:
		 Brush up on Phrase Library. Least Listens suggestion.
		 
		 
		 */
		
//		var lessonStartedSuggestions = [Lesson]()
//		var lessonNotStartedSuggestions = [Lesson]()
//
//		for lesson in self.lessons {
//
//
//			if !lesson.complete {
//				if lesson.lessonState == .started {
//					lessonStartedSuggestions.append(lesson)
//				}
//
//				if lesson.lessonState == .notStarted {
//					lessonNotStartedSuggestions.append(lesson)
//				}
//			}
//		}
//
//		var practiceStartedSuggestions = [Chat]()
//
//		for practice in self.chatQuestions {
//			if !practice.completed {
//				practiceStartedSuggestions.append(practice)
//			}
//		}
//
//		print("lessonStartedSuggestions:\(lessonStartedSuggestions.count) lessonNotStartedSuggestions:\(lessonNotStartedSuggestions.count) practiceStartedSuggestions:\(practiceStartedSuggestions.count)")
//
//
		let lessonStarted:Lesson? = self.lessons.first(where: { $0.lessonState == .started })
		let lessonNotStarted:Lesson? = self.lessons.first(where: { $0.lessonState == .notStarted })
		let chatStarted:PracticeChat? = self.chatQuestions.first(where: { $0.completed == false })
		let phrase:Phrase? = self.phrases.first ?? nil
		
		let lesson = (lessonStarted != nil) ? lessonStarted : lessonNotStarted
		
		return (lesson ,chatStarted, phrase)
		
		
		
	}
	//Transform from DB to internal chatting format
	/*
	 An array of Dictionaries
	 */
	func transformConversationsToChats(_ conversations:[Conversation]) -> [PracticeChat]
	{
		
//		printhires("TRANSFORM TO PRACTICE")
	
		guard conversations.isNotEmpty else {
			printhires("Conversation for \(libraryCode.code) is empty")
			return [PracticeChat]()
		}
		
		let groupedByConversation = OrderedDictionary(grouping: conversations, by: { $0.conversationNumber})
		
		var allChats = [PracticeChat]() //one chat with 1 person
		
		//If 3 people (conversations) then 3 loops here
		
		for key in groupedByConversation { //index, element in
			
			
			let conversations = key.value.sorted(by: { $0.sortNumber < $1.sortNumber })
			let conversationNumber = key.key
			print(conversationNumber)
			
			let questions = conversations //non mutable
			
			var messages = [ChatMessage]()
			var qn = 1 //question Number
			questions.forEach{ //all same conversationNumber collapsed in here -- maybe 11 loops?
				
				
				let conversation = $0
				
				if qn == 1 { //they will learn
					messages.append(ChatMessage(qn,"Can you tap the correct answer?.",.intro, .question))
				}
				messages.append(ChatMessage(qn,conversation.prompt,.prompt, .question))
				
				var randomArray = [ChatMessage]()
				randomArray.append(ChatMessage(qn,conversation.wrongChoice1,.wrong1, .question))
				randomArray.append(ChatMessage(qn,conversation.wrongChoice2,.wrong2, .question))
				randomArray.append(ChatMessage(qn,conversation.correctChoice,.correct, .question))
				randomArray.shuffle()
				messages.append(contentsOf: randomArray)
				
				messages.append(ChatMessage(qn,"Well done.😀",.congrats, .postCorrect))
				messages.append(ChatMessage(qn,conversation.correctExplanation,.correctExplanation, .postCorrect))
				if qn < key.value.count {
					messages.append(ChatMessage(qn,"Carry on?",.more, .postCorrect))
				}else{
					messages.append(ChatMessage(qn,"Completed",.complete, .postCorrect)) //at the end
					messages.append(ChatMessage(qn,"Restart Practice",.restart, .postCorrect)) //at the end
				}
				
				messages.append(ChatMessage(qn,"Sorry, try again",.incorrectResponse, .postWrong1))
				messages.append(ChatMessage(qn,conversation.wrong1Explanation,.incorrect1Explanation, .postWrong1))
				
				messages.append(ChatMessage(qn,"Sorry, try again.",.incorrectResponse, .postWrong2))
				messages.append(ChatMessage(qn,conversation.wrong2Explanation,.incorrect2Explanation, .postWrong2))
				
				
				qn += 1
				
				//for now just do 1. April 23 2023
				
			} //: For Each chat
			
			
			
			
			let questionCount = qn - 1
			
			var avatar = chooseAvatar(avatarArea: .practice, subarea: conversationNumber)
			avatar.questionCount = questionCount
			
			#if DONT_COMPILE
			questions.filter({$0.conversationNumber == 1}).forEach{
				print("\($0.id), cn:\($0.conversationNumber), sn:\($0.sortNumber),prompt:\($0.prompt.prefix(64)) ")
			}
			#endif
			
			
			//1 day debug - 1 chat only for Alex to review. 23 APril 2023
			allChats.append(PracticeChat(avatar: avatar, messages, spokenname: spokenName, initialQuestionNumber: 1,conversationNumber:conversationNumber )) //all conversationNumber in here
			
		} //groupBy Chat (Person) loop
		
		
		return allChats
	}//: func
	fileprivate func chooseAvatar(avatarArea:AvatarArea, subarea:Int) -> Avatar {
		
		//print(avatars.count)
		//print(avatars)
		if let a = avatars.first(where: {$0.area == avatarArea && $0.subarea == subarea}) {
			return a
		}else{
			//Oh No! not setup correctly in DB
			printhires("ERROR IN AVATAR SETUP ")
			return Avatar(name: "unknown \(subarea)",avatarArea: AvatarArea.practice, subTitle: "", imgString: "img1")
		}
		
		
	}
	func chooseAvatar(avatarArea:AvatarArea) -> Avatar {
		
//		print(avatars.count)
//		print(avatars)
		if let avatar = avatars.first(where: {$0.area == avatarArea}) {
			return avatar
		}else{
			//Oh No! not setup correctly in DB
			printhires("ERROR IN AVATAR SETUP ")
			return Avatar(name: "unknown",avatarArea: AvatarArea.practice, subTitle: "", imgString: "img1")
		}
		
		
	}
	//Lessons can have 2 dates set in DB - startDate and Enddate (e.g Christmas lessons December only)
	func removeNotStartedLessons(_ lessons:[Lesson]) -> [Lesson] {
		
		let today = Date()
		
		return lessons.filter{ ($0.startDate ... $0.endDate).contains(today) }
	}
}
extension DataManager{


	func removeCachedMP3sWithSpokenName() {
		
		//1. phrases
		for phrase in phrases {
			if phrase.phrase.contains(placeholder.spokenname) {
				let filename = "\(phrase.id).\(mp3_suffix)"
				if doesCachedFileExist(filename: filename) {
					print(phrase.phrase)
					removeFile(filename)
				}
			}
		}
		
		//2. practice
		for chatQuestion in chatQuestions {
			
			//1. prompts
			let promptMessages = chatQuestion.messageQ.filter({ $0.rowType == .prompt } )
			for prompt in promptMessages {
				
				if prompt.text.contains(placeholder.spokenname) {
					let UID = makePracticeUID(code: libraryCode.code,
														voiceName: voiceName,
														type: fb.prompt,
														conversationNumber: chatQuestion.conversationNumber,
														questionNumber: prompt.questionNumber)
					if doesCachedMP3FileExist(UID: UID) {
						let filename = "\(UID).\(mp3_suffix)"
						print(prompt.text)
						removeFile(filename)
					}
					
				}
				

			}
			
		
		//2. correct messages
			let correctMessages = chatQuestion.messageQ.filter({ $0.rowType == .correct } )
					
			for correct in correctMessages {
				if correct.text.contains(placeholder.spokenname) {
					let UID = makePracticeUID(code: libraryCode.code,
														voiceName: voiceName,
														type: fb.prompt,
														conversationNumber: chatQuestion.conversationNumber,
														questionNumber: correct.questionNumber)
					if doesCachedMP3FileExist(UID: UID) {
						let filename = "\(UID).\(mp3_suffix)"
						print(correct.text)
						removeFile(filename)
					}
				}
				
			}
			
		}
		
	}

}
