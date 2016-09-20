
import Models
import Common

/// A matcher that tests a string to see if it can represent a `SlackModelType`
public struct SlackModelTypePatternMatcher<T: SlackModelType & SlackModelIdentifiableType>: PartialPatternMatcher {
    let name: String?
    let token: String
    let model: T
    
    public func match(against string: String) -> PartialPatternMatch? {
        guard
            let modelId = string.remove(prefix: "<\(self.token)").substring(to: ">"),
            self.model.id == modelId
            else { return nil }
        
        return PartialPatternMatch(
            name: self.name,
            matched: "<\(self.token)\(modelId)>",
            value: self.model
        )
    }
}

extension User: PartialPatternMatcher {
    public func match(against string: String) -> PartialPatternMatch? {
        return SlackModelTypePatternMatcher(name: nil, token: "@", model: self)
            .match(against: string)
    }
}
extension User: PartialNamedPatternMatcher {
    public func match(against string: String, name: String) -> PartialPatternMatch? {
        return SlackModelTypePatternMatcher(name: name, token: "@", model: self)
            .match(against: string)
    }
}
extension User {
    public static func any(from sequence: [User]) -> (String) -> PartialPatternMatcher {
        return { return NamedSequencePatternMatcher(input: sequence, name: $0) }
    }
}

extension Channel: PartialPatternMatcher {
    public func match(against string: String) -> PartialPatternMatch? {
        return SlackModelTypePatternMatcher(name: nil, token: "#", model: self)
            .match(against: string)
    }
}
extension Channel: PartialNamedPatternMatcher {
    public func match(against string: String, name: String) -> PartialPatternMatch? {
        return SlackModelTypePatternMatcher(name: name, token: "#", model: self)
            .match(against: string)
    }
}
extension Channel {
    public static func any(from sequence: [Channel]) -> (String) -> PartialPatternMatcher {
        return { return NamedSequencePatternMatcher(input: sequence, name: $0) }
    }
}
