
/// Combine a `Sequence` of mixed _unnamed_ `PartialPatternMatcher`s into a single _named_ one
public struct MixedNamedSequencePatternMatcher<S: Sequence>: PartialPatternMatcher where S.Iterator.Element == PartialPatternMatcher {
    let input: S
    let name: String
    
    public func match(against string: String) -> PartialPatternMatch? {
        return self.input
            .lazy
            .flatMap { $0.match(against: string) }
            .map {
                return PartialPatternMatch(
                    name: self.name,
                    matched: $0.matched,
                    value: $0.value
                )
            }
            .first
    }
    
    public var matchDescription: String {
        let inputString = self.input
            .map { $0.matchDescription }
            .joined(separator: " or ")
        
        return "<\(inputString)>"
    }
}
