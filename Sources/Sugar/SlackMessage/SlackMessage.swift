import Models
import WebAPI
import Common

public class SlackMessage {
    //MARK: - Private Properties
    internal var options: [ChatPostMessageOption] = [.linkNames(true)]
    internal var messageSegments: [String] = []
    internal var attachments: [MessageAttachment] = []
    internal var responseType: MessageResponseType? = nil
    internal var responseUrl: String? = nil
    internal var replaceOriginal: Bool? = nil
    internal var deleteOriginal: Bool? = nil
    internal var customParameters: [String: String] = [:]
    
    //MARK: - Lifecycle
    /// Create a new `SlackMessage` instance to build a message to send
    public init() { }
    
    /**
     Create a `SlackMessage` from an existing `Message` instance
     */
    public init(message: Message) {
        self.messageSegments = message.text?.components(separatedBy: "\n") ?? []
        self.attachments = message.attachments ?? []
    }
    
    /**
     Set the `MessageResponseType`s to be used for this message
     
     - parameter value: The `MessageResponseType` to use
     
     - returns: The updated `SlackMessage` instance
     */
    public func respond(_ value: MessageResponseType) -> SlackMessage {
        self.responseType = value
        return self
    }

    /**
     Define what should happen to the original message if this is an update
     
     - parameter replace: Whether or not the original is replaced
     - parameter delete: Whether or not the original is deleted
     
     - returns: The updated `SlackMessage` instance
     */
    public func original(replace: Bool? = nil, delete: Bool? = nil) -> SlackMessage {
        self.replaceOriginal = replace
        self.deleteOriginal = delete
        return self
    }
    
    /**
     Set a custom url the created message will be sent to (used by responders)
     
     - parameter value: The url to use
     
     - returns: The updated `SlackMessage` instance
     */
    public func responseUrl(_ value: String) -> SlackMessage {
        self.responseUrl = value
        return self
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
        return self.line(segments)
    }
    
    /**
     Add a sequence of `SlackMessageSegment`s
     
     - parameter segments:   The sequence of `SlackMessageSegment`s to append to the message
     
     - returns: The updated `SlackMessage` instance
     */
    public func line(_ segments: [SlackMessageSegment]) -> SlackMessage {
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
    
    /**
     Set any custom parameters to include in the message
     
     - parameter value: The custom parameters to use
     
     - returns: The updated `SlackMessage` instance
     */
    func customParameters(_ value: [String: String]) -> SlackMessage {
        self.customParameters = value
        return self
    }
}
