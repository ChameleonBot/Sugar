import Bot

public protocol SlackInteractiveButtonResponderService: SlackInteractiveButtonService {
    var buttonResponder: SlackInteractiveButtonResponder { get }
    
    func register(callbackId: String, button: MessageAttachmentAction, with handler: @escaping InteractiveButtonResponseHandler)
    func registerButtons(from attachment: MessageAttachment, with handler: @escaping InteractiveButtonResponseHandler)
}

extension SlackInteractiveButtonResponderService {
    public func interactiveButton(slackBot: SlackBot, webApi: WebAPI, response: InteractiveButtonResponse) throws {
        try self.buttonResponder.interactiveButton(slackBot: slackBot, webApi: webApi, response: response)
    }
    public func register(callbackId: String, button: MessageAttachmentAction, with handler: @escaping InteractiveButtonResponseHandler) {
        self.buttonResponder.register(callbackId: callbackId, button: button, with: handler)
    }
    public func registerButtons(from attachment: MessageAttachment, with handler: @escaping InteractiveButtonResponseHandler) {
        self.buttonResponder.registerButtons(from: attachment, with: handler)
    }
}
