import Models
import WebAPI
import Foundation

extension SlackMessage: ChatPostMessageRepresentable {
    public func makeChatPostMessage(target: SlackTargetType) throws -> ChatPostMessage {
        return ChatPostMessage(
            target: target,
            text: self.messageSegments.joined(separator: ""),
            response_type: self.responseType,
            options: self.options,
            replaceOriginal: self.replaceOriginal,
            deleteOriginal: self.deleteOriginal,
            attachments: (self.attachments.isEmpty ? nil : self.attachments),
            customUrl: self.responseUrl.flatMap(URL.init)
        )
    }
}
