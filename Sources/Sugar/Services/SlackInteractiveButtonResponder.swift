import Bot

public typealias InteractiveButtonResponseHandler = (InteractiveButtonResponse) throws -> Void

public class SlackInteractiveButtonResponder {
    //MARK: - Properties
    private var responders: [String: InteractiveButtonResponseHandler] = [:]
    
    //MARK: - Lifecycle
    public init() { }
    
    //MARK: - Responder
    public func interactiveButton(slackBot: SlackBot, webApi: WebAPI, response: InteractiveButtonResponse) throws {
        guard let action = response.actions.first else { return }
        let key = "\(response.callback_id):\(action.name):\(action.value)"
        guard let responder = self.responders[key] else { return }
        try responder(response)
    }
    
    //MARK: - Public
    public func register(callbackId: String, button: MessageAttachmentAction, with handler: @escaping InteractiveButtonResponseHandler) {
        let key = "\(callbackId):\(button.name):\(button.value)"
        self.responders[key] = handler
    }
    public func registerButtons(from attachment: MessageAttachment, with handler: @escaping InteractiveButtonResponseHandler) {
        guard let callback_id = attachment.callback_id, let buttons = attachment.actions else { return }
        
        for button in buttons {
            self.register(callbackId: callback_id, button: button, with: handler)
        }
    }
}
