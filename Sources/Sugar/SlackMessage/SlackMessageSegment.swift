import Foundation
import Models

/// An abstraction that represents a type that builds a segment of a `SlackMessage`
public protocol SlackMessageSegment {
    var messageSegment: String { get }
}

extension SlackMessageSegment {
    /// Place the text in a pre block
    public var pre: SlackMessageSegment {
        return "```\(self.messageSegment)```"
    }
    
    /// Use inline code formatting
    public var code: SlackMessageSegment {
        return "`\(self.messageSegment)`"
    }
    
    /// Use italics
    public var italic: SlackMessageSegment {
        return "_\(self.messageSegment)_"
    }
    
    /// Use bold
    public var bold: SlackMessageSegment {
        return "*\(self.messageSegment)*"
    }
    
    /// Use strikethrough
    public var strike: SlackMessageSegment {
        return "~\(self.messageSegment)~"
    }
}

extension SlackMessageSegment {
    public var messageSegment: String { return String(describing: self) }
}

extension String: SlackMessageSegment { }
extension Int: SlackMessageSegment { }
extension Double: SlackMessageSegment { }
extension Bool: SlackMessageSegment { }
extension URL: SlackMessageSegment {
    public var messageSegment: String {
        let absoluteString: String? = self.absoluteString
        return absoluteString!
    }
}

extension Command: SlackMessageSegment {
    public var messageSegment: String { return self.command }
}
extension Emoji: SlackMessageSegment { }
extension CustomEmoji: SlackMessageSegment { }
extension SlackMessageSegment where Self: SlackEmoji  {
    public var messageSegment: String { return self.emojiSymbol }
}

extension User: SlackMessageSegment {
    public var messageSegment: String { return "<@\(self.id)>" }
}
extension Channel: SlackMessageSegment {
    public var messageSegment: String { return "<#\(self.id)>" }
}
