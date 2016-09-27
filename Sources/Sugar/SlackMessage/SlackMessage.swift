import Models
import WebAPI
import Common

public class SlackMessage {
    //MARK: - Private Properties
    internal var options: [ChatPostMessageOption] = [.linkNames(true)]
    internal var messageSegments: [String] = []
    internal var attachments: [MessageAttachment] = []
    internal var responseType: MessageResponseType?
    internal var responseUrl: String?
    internal var customParameters: [String: String] = [:]
    
    //MARK: - Lifecycle
    public init(responseType: MessageResponseType? = nil, responseUrl: String? = nil, replaceOriginal: Bool? = nil, deleteOriginal: Bool? = nil) {
        self.responseType = responseType
        self.responseUrl = responseUrl
        if let replaceOriginal = replaceOriginal {
            self.customParameters = self.customParameters + ["replace_original": (replaceOriginal ? "true" : "false")]
        }
        if let deleteOriginal = deleteOriginal {
            self.customParameters = self.customParameters + ["delete_original": (deleteOriginal ? "true" : "false")]
        }
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
