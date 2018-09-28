//
//  UserMessage.swift
//  MessageApp
//
//  Created by Sharon  Macasaol on 9/27/18.
//  Copyright © 2018 Sharon  Macasaol. All rights reserved.
//

import Foundation
import UIKit


struct Message{
    var userId: String?
    var userName: String?
    var userMessage: String?
}

struct User{
    var id: String?
    var username: String?
}


class UserMessage {
    static let shared = UserMessage()
    var loggedInUser: User?

}
