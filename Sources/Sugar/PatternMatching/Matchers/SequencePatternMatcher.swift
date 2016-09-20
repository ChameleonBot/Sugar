
/// A matcher that tests a string against a sequence of tests returning the first one that passes
public struct SequencePatternMatcher<S: Sequence>: PartialPatternMatcher where S.Iterator.Element: PartialPatternMatcher {
    let input: S
    
    public func match(against string: String) -> PartialPatternMatch? {
        return self.input
            .lazy
            .flatMap { $0.match(against: string) }
            .first
    }
}
