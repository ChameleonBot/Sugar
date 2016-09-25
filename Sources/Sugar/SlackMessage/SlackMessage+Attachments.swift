
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
}
