import WebAPI

/// Represents the possible outcomes of a `ConversationSegment`
public enum ConversationSegmentResult<Segment: RawRepresentable> where Segment.RawValue: Equatable {
    /// Proceed to the provided segment
    case next(segment: Segment)
    
    /// Complete the `Conversation` displaying an optional `ChatPostMessage`
    case complete(response: ChatPostMessage?)
}
