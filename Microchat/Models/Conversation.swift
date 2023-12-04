//
//  Conversation.swift
//  Microchat
//
//  Created by Jeff Shaul on 12/1/23.
//

import Foundation

struct Conversation: Equatable {
    var messages: [Message]
}

extension Conversation {
    static let mock = Conversation(messages: [
        Message(id: UUID(), content: "Knock knock", role: .ai),
        Message(id: UUID(), content: "Who's there?", role: .human),
        Message(id: UUID(), content: "SwiftUI", role: .ai),
        Message(id: UUID(), content: "SwiftUI who?", role: .human),
        Message(id: UUID(), content: "SwiftUI, where even the knock-knock interaction follows a declarative syntax!", role: .ai),
        Message(id: UUID(), content: "🙄🙄🙄", role: .human)
    ])
}
