
/// A matcher that tests a string against a sequence of tests returning the first one that passes
public struct NamedSequencePatternMatcher<S: Sequence>: PartialPatternMatcher where S.Iterator.Element: PartialNamedPatternMatcher {
    let input: S
    let name: String
    
    public func match(against string: String) -> PartialPatternMatch? {
        return self.input
            .lazy
            .flatMap { $0.match(against: string, name: name) }
            .first
    }
    
    public var matchDescription: String {
        return "<\(self.name)>"
    }
}
