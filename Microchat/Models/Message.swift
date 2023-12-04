//
//  Message.swift
//  Microchat
//
//  Created by Jeff Shaul on 12/1/23.
//

import Foundation

struct Message: Identifiable, Equatable {
    var id: UUID
    var content: String
    var role: ChatRole
    
    enum ChatRole {
        case human
        case ai
    }
}

extension Message {
    static let mock = Message(id: UUID(), content: "Hello world!", role: .ai)
}
