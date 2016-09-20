import Common

/// A simple matcher that tests the a string against a string version on the input, used to provide a naive default implementation 
public struct DefaultPatternMatcher<T>: PartialPatternMatcher {
    let input: T
    let name: String?
    
    public func match(against string: String) -> PartialPatternMatch? {
        let inputString = String(describing: self.input)
        guard string.lowercased().hasPrefix(inputString.lowercased()) else { return nil }
        
        return PartialPatternMatch(
            name: self.name,
            matched: string.substring(to: inputString.endIndex),
            value: self.input
        )
    }
    
    public var matchDescription: String {
        return String(describing: self.input)
    }
}
