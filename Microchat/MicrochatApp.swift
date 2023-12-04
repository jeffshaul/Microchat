//
//  MicrochatApp.swift
//  Microchat
//
//  Created by Jeff Shaul on 12/1/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct MicrochatApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView(
                store: Store(
                    initialState: ChatFeature.State(
                        conversation: Conversation.mock,
                        newMessage: ""
                    )
                ) {
                ChatFeature()
                }
            )
        }
    }
}
