import Bot

public protocol SlackConversationResponderService: SlackMessageService {
    var conversationResponder: SlackConversationResponder { get }
    
    func register<Segment: RawRepresentable, ConversationData>(conversation: Conversation<Segment, ConversationData>, webApi: WebAPI) where Segment.RawValue: Equatable
}
extension SlackConversationResponderService {
    public func register<Segment: RawRepresentable, ConversationData>(conversation: Conversation<Segment, ConversationData>, webApi: WebAPI) where Segment.RawValue: Equatable {
        self.conversationResponder.register(conversation: conversation, webApi: webApi)
    }
    
    public func messageEvent(slackBot: SlackBot, webApi: WebAPI, message: MessageDecorator, previous: MessageDecorator?) throws {
        try self.conversationResponder.handleMessage(message: message, webApi: webApi)
    }
}
