//
//  ChatView.swift
//  Microchat
//
//  Created by Jeff Shaul on 12/1/23.
//

import ComposableArchitecture
import SwiftUI

struct ChatView: View {
    let store: StoreOf<ChatFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(viewStore.state.conversation.messages) { message in
                            MessageBubbleView(message: message)
                        }
                    }
                    .onChange(of: viewStore.state.conversation.messages) { oldMessages, newMessages in
                        if let lastMessage = newMessages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                HStack {
                    TextField("Message", text: viewStore.$newMessage)
                    Button {
                        viewStore.send(.sendButtonTapped)
                    } label: {
                        Image(systemName: "paperplane")
                    }
                    .disabled(viewStore.newMessage.isEmpty)
                }
                .padding()
            }
            .onAppear {
                viewStore.send(.viewAboutToAppear)
            }
            .onDisappear {
                viewStore.send(.viewAboutToDisappear)
            }
        }
    }
}

#Preview {
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
