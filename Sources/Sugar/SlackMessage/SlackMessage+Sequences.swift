
extension SlackMessage {
    /**
     Add an attachment to the message for each item in a sequence
     
     - parameter for: The `Sequence` containing the items
     - parameter factory: A closure providing a item from the `Sequence` and the `SlackMessage`
     - returns: The updated `SlackMessage`
     */
    public func lines<S: Sequence>(for sequence: S, factory: (SlackMessage, S.Iterator.Element) -> SlackMessage) -> SlackMessage {
        return sequence.reduce(self) { message, item in
            return factory(message, item)
        }
    }
    
    /**
     Add an attachment to the message for each item in a sequence
     
     - parameter for: The `Sequence` containing the items
     - parameter factory: A closure providing a item from the `Sequence` and a `SlackMessageAttachmentBuilder` instance used to create an attachment
     - returns: The updated `SlackMessage`
     */
    public func attachments<S: Sequence>(for sequence: S, factory: (SlackMessageAttachmentBuilder, S.Iterator.Element) -> Void) -> SlackMessage {
        return sequence.reduce(self) { message, item in
            return message.attachment { builder in
                return factory(builder, item)
            }
        }
    }
}
