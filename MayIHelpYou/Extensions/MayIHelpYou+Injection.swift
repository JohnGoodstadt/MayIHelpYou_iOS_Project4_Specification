//
//  MayIHelpYou+Injection.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 23/03/2023.
//

import Foundation
import Firebase
import Resolver

#if DONT_COMPILE
extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
	  // register Firebase services
	  register { Firestore.enableLogging(true) }.scope(.application)
	  
	  // register application components
	  //register { AuthenticationService() }.scope(.application)
	  
	//register { TestDataTaskRepository() as TaskRepository }.scope(application)
  }
}
#endif
