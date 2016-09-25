import Models
import WebAPI

extension SlackMessage: ChatPostMessageRepresentable {
    public func makeChatPostMessage(target: SlackTargetType) throws -> ChatPostMessage {
        return ChatPostMessage(
            target: target,
            text: self.messageSegments.joined(separator: ""),
            response_type: nil,
            options: self.options,
            customParameters: nil,
            attachments: (self.attachments.isEmpty ? nil : self.attachments),
            customUrl: nil
        )
    }
}
