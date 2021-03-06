/*
 *	UserService.swift
 *	LocalServer
 *
 *	Created by Diney Bomfim on 3/9/19.
 *	Copyright 2019. All rights reserved.
 */

import Foundation
import LocalServer

// MARK: - Type -

final class UserService {
	
// MARK: - Exposed Methods
	
	static func single(_ type: UserType) {
		UITestResponse(filename: "user_\(type.file)", ofType: "json", bundle: .uiTest)
			.send(to: "format")
	}
	
	static func singleWithDetails(_ type: UserType) {
		single(type)
		
		UITestResponse(filename: "picture_\(type.file)", ofType: "jpg", bundle: .uiTest)
			.withHeaders(["Content-type" : "image"])
			.send(to: "portraits")
	}
	
	static func singleWithMoreInfo(_ type: UserType) {
		singleWithDetails(type)
		
		UITestResponse(filename: "user_\(type.file)", ofType: "html", bundle: .uiTest)
			.send(to: "index")
	}
	
	static func statefulSequence(_ types: [UserType]) {
		types.enumerated().forEach {
			var response = UITestResponse(filename: "user_\($1.file)", ofType: "json", bundle: .uiTest)
			
			switch $0 + 1 {
			case 1:
				response = response.willSetStateTo("\($0 + 1)")
			case 2..<types.count:
				response = response.whenStateIs("\($0)").willSetStateTo("\($0 + 1)")
			default:
				response = response.whenStateIs("\($0)")
			}
			
			response.send(to: "randomuser.me/api/")
		}
	}
}
