import Models
import WebAPI

/// An abstraction representing something that can be turned into a `ChatPostMessage`
public protocol ChatPostMessageRepresentable {
    /**
     Convert this object into a `ChatPostMessage`
     
     - parameter target: The `SlackTargetType` the resulting `ChatPostMessage` will be sent to
     - returns: A new `ChatPostMessage` instance
     */
    func makeChatPostMessage(target: SlackTargetType) throws -> ChatPostMessage
}
