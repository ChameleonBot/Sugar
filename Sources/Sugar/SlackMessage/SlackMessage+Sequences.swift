
public extension SlackMessage {
    public func attachments<S: Sequence>(for sequence: S, factory: (SlackMessageAttachmentBuilder, S.Iterator.Element) -> Void) -> SlackMessage {
        return sequence.reduce(self) { message, item in
            return message.attachment { builder in
                return factory(builder, item)
            }
        }
    }
}
