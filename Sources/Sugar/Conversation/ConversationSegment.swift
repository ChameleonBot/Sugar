import Models
import WebAPI

public struct ConversationSegment<Segment: RawRepresentable, ConversationData> where Segment.RawValue: Equatable {
    //MARK: - Typealiases
    public typealias DataUpdateClosure = (ConversationData?) -> Void
    
    public typealias MessageClosure = (User, SlackTargetType, PatternMatchResult) throws -> ChatPostMessage?
    public typealias ListenClosure = (User, SlackTargetType, PatternMatchResult) -> [PartialPatternMatcher]
    public typealias ResponderClosure = (User, SlackTargetType, PatternMatchResult, ConversationData?, DataUpdateClosure) throws -> ConversationSegmentResult<Segment>
    
    //MARK: - Properties
    let name: Segment
    let message: MessageClosure
    let listenFor: ListenClosure
    let responder: ResponderClosure
    
    //MARK: - Lifecycle
    public init(
        name: Segment,
        message: @escaping MessageClosure,
        listenFor: @escaping ListenClosure,
        responder: @escaping ResponderClosure)
    {
        self.name = name
        self.message = message
        self.listenFor = listenFor
        self.responder = responder
    }
}
