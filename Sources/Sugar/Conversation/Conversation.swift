import Models
import WebAPI

public class Conversation<Segment: RawRepresentable, ConversationData> where Segment.RawValue: Equatable {
    //MARK: - Typealiases
    public typealias InvalidResponseClosure = (User, SlackTargetType, String) throws -> ChatPostMessage?
    public typealias UpdatedDataClosure = (User, SlackTargetType, ConversationData?) throws -> Void
    typealias NewConversationClosure = (ActiveConversation<Segment, ConversationData>, PatternMatchResult) throws -> Void
    
    //MARK: - Properties
    var segments: [ConversationSegment<Segment, ConversationData>] = []
    private let trigger: [PartialPatternMatcher]
    private let startingSegment: Segment
    private let initialData: (() -> ConversationData)?
    var invalidResponse: InvalidResponseClosure?
    var updatedData: UpdatedDataClosure?
    var newConversation: NewConversationClosure?
    
    //MARK: - Lifecycle
    public init(
        trigger: [PartialPatternMatcher],
        starting segment: Segment,
        initialData: @autoclosure @escaping () -> (() -> ConversationData)? = nil)
    {
        self.trigger = trigger
        self.startingSegment = segment
        self.initialData = initialData()
    }
    
    //MARK: - Public Functions
    public func add(segment: ConversationSegment<Segment, ConversationData>) -> Conversation {
        self.segments.append(segment)
        return self
    }
    public func handle(invalid response: InvalidResponseClosure?) -> Conversation {
        self.invalidResponse = response
        return self
    }
    public func handle(data update: UpdatedDataClosure?) -> Conversation {
        self.updatedData = update
        return self
    }
    
    //MARK: - Internal
    func handleMessage(message: MessageDecorator) throws {
        guard let user = message.sender, let target = message.target else { return }
        
        try message.routeText(
            to: self.converse(with: user, in: target),
            matching: self.trigger
        )
    }
    
    //MARK: - Private
    private func converse(with user: User, in target: SlackTargetType) -> (PatternMatchResult) throws -> Void {
        return { match in
            let activeConversation = ActiveConversation(
                conversation: self,
                user: user,
                target: target,
                starting: self.startingSegment,
                invalidResponse: self.invalidResponse,
                initialData: self.initialData?(),
                updatedData: self.updatedData
            )
            try self.newConversation?(activeConversation, match)
        }
    }
}
