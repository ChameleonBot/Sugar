import WebAPI

public class SlackConversationResponder {
    //MARK: - Typealias
    typealias ConversationTriggerHandler = (MessageDecorator) throws -> Void
    typealias ActiveConversationMessageHandler = (MessageDecorator, WebAPI) throws -> Void
    
    //MARK: - Properties
    private var conversations: [ConversationTriggerHandler] = []
    private var activeConversations: [String: ActiveConversationMessageHandler] = [:]
    
    //MARK: - Lifecycle
    public init() { }
    
    //MARK: - Public
    public func register<Segment: RawRepresentable, ConversationData>(conversation: Conversation<Segment, ConversationData>, webApi: WebAPI) where Segment.RawValue: Equatable {
        conversation.newConversation = { conversation, match in
            let key = "\(conversation.user.id):\(conversation.target.id)"
            guard !self.activeConversations.keys.contains(key) else { return }
            
            conversation.segmentResult = { result in
                switch result {
                case .complete:
                    self.activeConversations[key] = nil
                case .next:
                    break
                }
            }
            
            self.activeConversations[key] = conversation.handleMessage
            try conversation.start(match: match, webApi: webApi)
        }
        self.conversations.append(conversation.handleMessage)
    }
    
    //MARK: - Internal
    func handleMessage(message: MessageDecorator, webApi: WebAPI) throws {
        guard let user = message.sender, let target = message.target?.instantMessage else { return }
        
        let key = "\(user.id):\(target.id)"
        if let activeConversation = self.activeConversations[key] {
            try activeConversation(message, webApi)
        } else {
            try self.conversations.forEach { try $0(message) }
        }
    }
}
