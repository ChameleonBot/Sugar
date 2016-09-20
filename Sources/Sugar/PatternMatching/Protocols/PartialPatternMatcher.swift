
/// An abstraction that represents a type that can be used to perform a pattern match test
public protocol PartialPatternMatcher {
    /**
     Tests a `String` against this `PartialNamedPatternMatcher` instance
     
     - parameter against: The `String` to attempt to find a partial match in
     - returns: A new `PartialPatternMatch` instance if matching was successful, otherwise `nil`
     */
    func match(against string: String) -> PartialPatternMatch?
}

extension PartialPatternMatcher {
    public func match(against string: String) -> PartialPatternMatch? {
        return DefaultPatternMatcher(input: self, name: nil).match(against: string)
    }
}

extension String: PartialPatternMatcher { }
extension Int: PartialPatternMatcher { }
extension Double: PartialPatternMatcher { }
extension Bool: PartialPatternMatcher { }

extension Sequence where Iterator.Element: PartialPatternMatcher {
    /**
     Converts the receiver into a `PartialPatternMatcher` test that can be used in pattern matching
     
     - returns: A new `PartialPatternMatcher` instance to be used in pattern matching
     */
    public func any() -> PartialPatternMatcher {
        return SequencePatternMatcher(input: self)
    }
}
