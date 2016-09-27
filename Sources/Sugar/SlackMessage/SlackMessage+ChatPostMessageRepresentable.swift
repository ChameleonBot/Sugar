import Models
import WebAPI
import Foundation

extension SlackMessage: ChatPostMessageRepresentable {
    public func makeChatPostMessage(target: SlackTargetType) throws -> ChatPostMessage {
        return ChatPostMessage(
            target: target,
            text: self.messageSegments.joined(separator: ""),
            response_type: self.response_type,
            options: self.options,
            customParameters: nil,
            attachments: (self.attachments.isEmpty ? nil : self.attachments),
            customUrl: self.response_url.flatMap(URL.init)
        )
    }
}
