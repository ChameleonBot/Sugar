import Models
import Foundation

extension SlackMessageAttachmentBuilder {
    /// Add a new interactive button to the attachment, will use the default responder
    public func button(
        name: String, text: String, value: String? = nil,
        style: MessageAttachmentActionStyle? = .default,
        confirmation: MessageAttachmentActionConfirmation? = nil) {
        
        _ = self.newButton(
            name: name,
            text: text,
            value: value,
            style: style,
            confirmation: confirmation
        )
        
    }
    
    /**
     Add a new interactive button to the attachment,
     will use the provided `SlackInteractiveButtonResponderService`
     to handle the button action with the `InteractiveButtonResponseHandler`
     */
    public func button(
        name: String, text: String, value: String? = nil,
        style: MessageAttachmentActionStyle? = .default,
        confirmation: MessageAttachmentActionConfirmation? = nil,
        responder: SlackInteractiveButtonResponderService,
        handler: @escaping InteractiveButtonResponseHandler) {
        
        let button = self.newButton(
            name: name,
            text: text,
            value: value,
            style: style,
            confirmation: confirmation
        )
        
        responder.register(callbackId: button.callbackId, button: button.button, with: handler)
    }
    
    /**
     Remove a specific button from the attachment
     */
    public func remove(button: MessageAttachmentAction) {
        guard let index = self.attachment.actions?.index(of: button) else { return }
        self.attachment.actions?.remove(at: index)
    }
    
    /**
     Remove any button matching the provided condition from the attachment
     */
    public func removeButtons(matching condition: (MessageAttachmentAction) -> Bool) {
        let actions = self.attachment.actions ?? []
        for action in actions {
            if (condition(action)) {
                self.remove(button: action)
            }
        }
    }
}

//MARK: - Button Factory Helper
fileprivate extension SlackMessageAttachmentBuilder {
    func newButton(
        name: String, text: String, value: String? = nil,
        style: MessageAttachmentActionStyle? = .default,
        confirmation: MessageAttachmentActionConfirmation? = nil
        ) -> (button: MessageAttachmentAction, callbackId: String) {
        
        let button = MessageAttachmentAction(
            name: name,
            text: text,
            style: style,
            type: "button",
            value: value ?? name,
            confirm: confirmation
        )
        
        var actions = self.attachment.actions ?? []
        actions.append(button)
        self.attachment.actions = actions
        
        let callbackId = self.attachment.callback_id ?? NSUUID().uuidString
        self.attachment.callback_id = callbackId
        
        return (button, callbackId)
    }
}

//TODO: should end up in `Models` framework
extension MessageAttachmentAction: Equatable { }
public func ==(lhs: MessageAttachmentAction, rhs: MessageAttachmentAction) -> Bool {
    return (
        lhs.name == rhs.name &&
        lhs.text == rhs.text &&
        lhs.style == rhs.style &&
        lhs.type == rhs.type &&
        lhs.value == rhs.value &&
        lhs.confirm?.title == rhs.confirm?.title &&
        lhs.confirm?.text == rhs.confirm?.text &&
        lhs.confirm?.ok_text == rhs.confirm?.ok_text &&
        lhs.confirm?.dismiss_text == rhs.confirm?.dismiss_text
    )
}
