
/// A simple matcher that tests the a string against a string version on the input, used to provide a naive default implementation 
public struct DefaultPatternMatcher<T>: PartialPatternMatcher {
    let input: T
    let name: String?
    
    public func match(against string: String) -> PartialPatternMatch? {
        let inputString = String(describing: self.input)
        guard string.hasPrefix(inputString) else { return nil }
        
        return PartialPatternMatch(
            name: self.name,
            matched: inputString,
            value: self.input
        )
    }
}
