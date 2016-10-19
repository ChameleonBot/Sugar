
/// Describes a range of errors that can occur while interacting with conversations
public enum ConversationError: Error, CustomStringConvertible {
    /// A provided `Segment` was not added to the parent `Conversation`
    case unknownSegment(value: Any)
    
    /// The `Conversation` has found itself in an invalid state
    case invalidState
    
    public var description: String {
        switch self {
        case .unknownSegment(let value): return "The segment '\(value)' was not found"
        case .invalidState: return "The Conversation is in an invalid state"
        }
    }
}
