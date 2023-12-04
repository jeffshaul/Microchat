//
//  ChatFeature.swift
//  Microchat
//
//  Created by Jeff Shaul on 12/1/23.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ChatFeature {
    struct State: Equatable {
        var conversation: Conversation
        @BindingState var newMessage: String
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case receiveDelta(String)
        case sendButtonTapped
        case viewAboutToAppear
        case viewAboutToDisappear
    }
    
    @Dependency(\.chat) var chat
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case let .receiveDelta(delta):
                state.conversation.messages[state.conversation.messages.count - 1].content.append(delta)
                return .none
                
            case .sendButtonTapped:
                let message = Message(id: UUID(), content: state.newMessage, role: .human)
                state.conversation.messages.append(message)
                state.conversation.messages.append(Message(id: UUID(), content: "", role: .ai))
                state.newMessage = ""
                return .run { send in
                    for await event in await self.chat.send(message) {
                        await send(.receiveDelta(event))
                    }
                }
                
            case .viewAboutToAppear:
                self.chat.connect(URL(string: "wss://ws.postman-echo.com/raw/")!)
                return .none
                
            case .viewAboutToDisappear:
                self.chat.disconnect()
                return .none
            }
        }
    }
}
