import Bot
import Common

public struct MessageDecorator {
    //MARK: - Private Properties
    private let slackModels: () -> SlackModels
    
    //MARK: - Public Properties
    public let message: Message
    
    //MARK: - Public Derived Properties
    /// `String` representing the text of the `Message`
    public var text: String { return self.message.text ?? "" }
    
    /// The `User` representing the sender of this `Message`
    public var sender: User? {
        return
            self.message.user ??
                self.message.edited?.user ??
                self.message.inviter ??
                self.message.bot
    }
    
    /// The `SlackTargetType` for this `Message`
    public var target: SlackTargetType? {
        return self.message.channel
    }
    
    /// A sequence of mentioned `User`s in the `Message`
    public var mentioned_users: [MessageLink<User>] {
        let users = slackModels().users + slackModels().users.botUsers()
        
        return self.mentionedLinks { match in
            guard match.string.hasPrefix("@") else { return nil }
            let id = match.string.substring(from: 1)
            return users.first(where: { $0.id == id })
        }
    }
    
    /// A sequence of mentioned `Channel`s in the `Message`
    public var mentioned_channels: [MessageLink<Channel>] {
        let channels = slackModels().channels
        
        return self.mentionedLinks { match in
            guard match.string.hasPrefix("#") else { return nil }
            let id = match.string.substring(from: 1)
            return channels.first(where: { $0.id == id })
        }
    }
    
    /// A sequence of mentioned `Command`s in the `Message`
    public var mentioned_actions: [MessageLink<Command>] {
        return self.mentionedLinks { match in
            guard match.string.hasPrefix("!") else { return nil }
            let command = match.string.substring(from: 1)
            
            if command == "channel" {
                return .channel
            } else if command == "group" {
                return .group
            } else if command == "here" {
                return .here
            } else if command == "everyone" {
                return .everyone
            } else if command.hasPrefix("subteam^") {
                let idName = command
                    .substring(from: "subteam^".characters.count)
                    .components(separatedBy: "|")
                
                guard
                    let id = idName.first,
                    let name = idName.last
                    else { return nil }
                
                return .userGroup(id: id, name: name)
                
            } else {
                return .custom(name: command)
            }
        }
    }
    
    /// A sequence of mentioned `MessageLink`s in the `Message` that are not `Channel`s, `User`s or `Command`s
    public var mentioned_links: [MessageLink<(title: String, link: String)>] {
        return self.mentionedLinks { match in
            guard
                !match.string.hasPrefix("@"),
                !match.string.hasPrefix("#"),
                !match.string.hasPrefix("!")
                else { return nil }
            
            let components = match.string.components(separatedBy: "|")
            
            guard
                let first = components.first,
                let last = components.last
                else { return nil }
            
            return (first, last)
        }
    }
    
    //MARK: - Lifecycle
    init(message: Message, slackModels: @escaping () -> SlackModels) {
        self.message = message
        self.slackModels = slackModels
    }
}

//MARK: - Link Extraction
fileprivate extension MessageDecorator {
    typealias RegexMatch = (range: Range<String.Index>, string: String)
    
    func mentionedLinks<T>(factory: (RegexMatch) -> T?) -> [MessageLink<T>] {
        let links: [RegexMatch] = (try? self.text.substrings(matching: "<(.*?)>")) ?? []
        return links
            .map { match -> RegexMatch in
                //TODO: needed bcause capture groups aren't currently supported
                // written in a way that if it gets left by mistake nothing will break
                var range = match.range
                if match.string.hasPrefix("<") {
                    range = text.index(after: range.lowerBound)..<range.upperBound
                }
                if match.string.hasSuffix(">") {
                    range = range.lowerBound..<text.index(before: range.upperBound)
                }
                
                return (range, text.substring(with: range))
            }
            .flatMap { match in
                guard let value = factory(match) else { return nil }
                return MessageLink(range: match.range, value: value)
            }
    }
}

//MARK: - MessageLink
/// Represents a link extracted from a `Message`
public struct MessageLink<T> {
    public let range: Range<String.Index>
    public let value: T
}

//MARK: - Factory
extension Message {
    func makeDecorator(slackModels: @escaping () -> SlackModels) -> MessageDecorator {
        return MessageDecorator(message: self, slackModels: slackModels)
    }
}
