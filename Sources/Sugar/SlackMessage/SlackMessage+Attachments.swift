import Common
import Models

extension SlackMessage {
    /**
     Add an attachment to the message
     
     - parameter factory: A closure providing a `SlackMessageAttachmentBuilder` instance used to create an attachment
     - returns: The updated `SlackMessage`
     */
    public func attachment(factory: (SlackMessageAttachmentBuilder) -> Void) -> SlackMessage {
        let builder = SlackMessageAttachmentBuilder()
        factory(builder)
        self.attachments.append(builder.makeMessageAttachment())
        return self
    }
        
    /**
     Update an attachment in the message with the provided callback_id
     
     - parameter callback_id: The callback_id of the attachment
     - parameter factory: A closure providing a `SlackMessageAttachmentBuilder` instance used to update the attachment - it will have the data from the existing attachment
     - returns: The updated `SlackMessage`
     */
    public func updateAttachment(callback_id: String, factory: (SlackMessageAttachmentBuilder) -> Void) -> SlackMessage {
        guard let attachment = self.attachments.filter({ $0.callback_id == callback_id }).first else { return self }
        
        let builder = SlackMessageAttachmentBuilder(attachment: attachment)
        factory(builder)
        self.attachments = self.attachments.replaceFirst(
            matching: { $0.callback_id == callback_id },
            with: builder.makeMessageAttachment()
        )
        return self
    }
    
    /**
     Update an attachment in the message containing the button that provided a `InteractiveButtonResponse`
     
     - parameter buttonResponse: The `InteractiveButtonResponse` provided from an interactive button respone handler
     - parameter factory: A closure providing a `SlackMessageAttachmentBuilder` instance used to update the attachment - it will have the data from the existing attachment
     - returns: The updated `SlackMessage`
     */
    public func updateAttachment(buttonResponse: InteractiveButtonResponse, factory: (SlackMessageAttachmentBuilder) -> Void) -> SlackMessage {
        return self.updateAttachment(callback_id: buttonResponse.callback_id, factory: factory)
    }
}
