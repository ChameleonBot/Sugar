import Models
import WebAPI

public class SlackMessage {
    //MARK: - Private Properties
    internal var options: [ChatPostMessageOption] = [.linkNames(true)]
    internal var messageSegments: [String] = []
    internal var attachments: [MessageAttachment] = []
    internal var response_type: MessageResponseType?
    internal var response_url: String?
    
    //MARK: - Lifecycle
    public init(response_type: MessageResponseType? = nil, response_url: String? = nil) {
        self.response_type = response_type
        self.response_url = response_url
    }
    
    /**
     Set the `ChatPostMessageOption`s to be used for this `SlackMessageSegment`s
     
     - parameter options:   The sequence of `ChatPostMessageOption`s to use for this message
     
     - returns: The updated `SlackMessage` instance
     */
    public func options(_ options: [ChatPostMessageOption]) -> SlackMessage {
        self.options = options
        return self
    }
    
    /**
     Add a `SlackMessageSegment`
     
     - parameter segment:   The `SlackMessageSegment` to append to the message
     - parameter newLine:   Whether a new line should be added (defaults to `false`)
     
     - returns: The updated `SlackMessage` instance
     */
    public func add(segment: SlackMessageSegment, newLine: Bool = false) -> SlackMessage {
        self.messageSegments.append(segment.messageSegment)
        return (newLine ? self.newLine() : self)
    }
    
    /**
     Add a sequence of `SlackMessageSegment`s
     
     - parameter segments:   The sequence of `SlackMessageSegment`s to append to the message
     
     - returns: The updated `SlackMessage` instance
     */
    public func line(_ segments: SlackMessageSegment...) -> SlackMessage {
        self.messageSegments.append(contentsOf: segments.map({ $0.messageSegment }))
        return self.newLine()
    }
    
    /**
     Add a new line to the `SlackMessage`
     
     - returns: The updated `SlackMessage` instance
     */
    public func newLine() -> SlackMessage {
        self.messageSegments.append("\n")
        return self
    }
}
