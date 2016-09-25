import Models
import WebAPI
import Bot

/// An abstraction representing something that can be turned into a `ChatPostMessage` that supports an interactive button responder
public protocol InteractiveButtonChatPostMessageRepresentable {
    /**
     Convert this object into a `ChatPostMessage`
     
     - parameter target: The `SlackTargetType` the resulting `ChatPostMessage` will be sent to
     - parameter responder: The `SlackInteractiveButtonService` that will be used to deliver responses to the buttons
     - parameter handler: The `InteractiveButtonResponseHandler` closure that will handle the `InteractiveButtonResponse` itself
     - returns: A new `ChatPostMessage` instance
     */
    func makeInteractiveButtonChatPostMessage(
        target: SlackTargetType,
        responder: SlackInteractiveButtonResponderService,
        handler: @escaping InteractiveButtonResponseHandler) throws -> ChatPostMessage
}
