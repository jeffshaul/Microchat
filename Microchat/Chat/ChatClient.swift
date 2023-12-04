//
//  ChatClient.swift
//  Microchat
//
//  Created by Jeff Shaul on 12/1/23.
//

import ComposableArchitecture
import Foundation

struct ChatClient {
    private static var task: URLSessionWebSocketTask? = nil
    var connect: (_ url: URL) -> Void
    var disconnect: () -> Void
    var send: (_ message: Message) async -> AsyncStream<String>
}

extension ChatClient {
    static let live = Self(
        connect: { url in
            task = URLSession.shared.webSocketTask(with: url)
            task!.resume()
        },
        disconnect: {
            task?.cancel(with: .normalClosure, reason: nil)
        },
        send: { message in
            let webSocketStream = AsyncStream<String> { continuation in
                Task {
                    do {
                        try await task!.send(URLSessionWebSocketTask.Message.string(message.content))
                        task!.receive { result in
                            switch result {
                            case let .success(resultContent):
                                switch resultContent {
                                case let .string(resultString):
                                    continuation.yield(resultString)
                                case let .data(resultData):
                                    continuation.finish()
                                @unknown default:
                                    continuation.finish()
                                }
                            case let .failure(resultContent):
                                continuation.finish()
                            }
                        }
                    } catch {
                        continuation.finish()
                    }
                }
            }
            
            return webSocketStream
        }
    )
    static let preview = live
}

extension ChatClient {
    static let test = Self(
        connect: { url in
            
        },
        disconnect: {
            
        },
        send: { message in
            let letterStream = AsyncStream<String> { continuation in
                Task {
                    for char in message.content {
                        try! await Task.sleep(nanoseconds: 100_000_000)
                        continuation.yield(String(char))
                    }
                }
            }
            
            return letterStream
        }
    )
}

private enum ChatClientKey: DependencyKey {
    static let liveValue = ChatClient.live
    static let testValue = ChatClient.live
    static let previewValue = ChatClient.preview
}

extension DependencyValues {
    var chat: ChatClient {
        get { self[ChatClientKey.self] }
        set { self[ChatClientKey.self] = newValue }
    }
}
