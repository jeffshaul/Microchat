//
//  MessageBubbleView.swift
//  Microchat
//
//  Created by Jeff Shaul on 12/1/23.
//

import SwiftUI

struct MessageBubbleView: View {
    
    var message: Message
    
    private var backgroundColor: Color {
        return message.role == .ai ? .gray : .blue
    }
    
    private var avatar: Image {
        return Image(systemName: message.role == .ai ? "gear" : "person.fill")
    }
    
    private var side: LayoutDirection {
        return message.role == .ai ? .leftToRight : .rightToLeft
    }
    
    private var cornerRadii: RectangleCornerRadii {
        switch message.role {
        case .ai:
            return RectangleCornerRadii(
                bottomTrailing: 25.0,
                topTrailing: 25.0
            )
        case .human:
            return RectangleCornerRadii(
                topLeading: 25.0,
                bottomLeading: 25.0
            )
        }
    }
    
    var body: some View {
        HStack {
            message.role == .human ? Spacer() : nil
            
            VStack {
                HStack(alignment: .top) {
                    avatar
                        .padding(3)
                    Text(message.content)
                }
                .environment(\.layoutDirection, side)
            }
            .padding()
            .background(backgroundColor)
            .clipShape(UnevenRoundedRectangle(
                cornerRadii: cornerRadii,
                style: .circular
            ))
            
            message.role == .ai ? Spacer() : nil
        }
    }
}

#Preview {
    ScrollView {
        ForEach(Conversation.mock.messages) { mockMessage in
            MessageBubbleView(message: mockMessage)
        }
    }
}
