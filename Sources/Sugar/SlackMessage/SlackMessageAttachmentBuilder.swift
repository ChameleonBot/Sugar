import Models
import Foundation

public class SlackMessageAttachmentBuilder {
    //MARK: - Private Properties
    fileprivate var attachment = MessageAttachment(
        fallback: "", color: nil, pretext: nil,
        author_name: nil, author_link: nil, author_icon: nil,
        title: nil, title_link: nil,
        text: nil,
        fields: nil, actions: nil,
        from_url: nil, image_url: nil, thumb_url: nil,
        callback_id: nil, attachment_type: nil,
        mrkdwn_in: nil,
        footer: nil, footer_icon: nil,
        ts: nil
    )
    
    /// Attachment colour
    public func color(_ color: SlackColor) {
        self.attachment.color = color
    }
    
    /// Text that appears above the attachment block
    public func pretext(_ value: String) {
        self.attachment.pretext = value
    }
    
    /// Author information
    public func author(name: String? = nil, link: String? = nil, icon: String? = nil) {
        self.attachment.author_name = name
        self.attachment.author_link = link
        self.attachment.author_icon = icon
    }
    
    /// Attachment title
    public func title(name: String? = nil, link: String? = nil) {
        self.attachment.title = name
        self.attachment.title_link = link
    }
    
    /// Text that appears within the attachment
    public func text(_ value: String) {
        self.attachment.text = value
    }
    
    /// Add a field to the attachment
    public func field(short: Bool, title: String, value: String) {
        var fields = self.attachment.fields ?? []
        fields.append(MessageAttachmentField(title: title, value: value, short: short))
        self.attachment.fields = fields
    }
    
    /// Attachment Image
    public func image(url: String) {
        self.attachment.image_url = url
    }
    
    /// Attachment thumbnail image
    public func thumbnail(url: String) {
        self.attachment.thumb_url = url
    }
    
    /// Footer for information
    public func footer(name: String, icon: String? = nil) {
        self.attachment.footer = name
        self.attachment.footer_icon = icon
    }
    
    /// Timestamp for attachment
    public func timestamp(_ value: Int) {
        self.attachment.ts = value
    }
    
    func makeMessageAttachment() -> MessageAttachment {
        return self.attachment
    }
}

extension SlackMessageAttachmentBuilder {
    private func newButton(
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
}
