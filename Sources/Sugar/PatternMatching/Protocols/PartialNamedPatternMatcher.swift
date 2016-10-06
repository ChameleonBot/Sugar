
/// An abstraction that represents a type that can be used to perform a pattern match test
public protocol PartialNamedPatternMatcher {
    /**
     Tests a `String` against this `PartialNamedPatternMatcher` instance
     
     - parameter against: The `String` to attempt to find a partial match in
     - parameter name: The name to use if this test has a successful match
     - returns: A new `PartialPatternMatch` instance if matching was successful, otherwise `nil`
     */
    func match(against string: String, name: String) -> PartialPatternMatch?
    
    /// Human readable representation of this portion of the pattern
    var matchDescription: String { get }
}

extension PartialNamedPatternMatcher {
    public func match(against string: String, name: String) -> PartialPatternMatch? {
        return DefaultPatternMatcher(input: self, name: name).match(against: string)
    }
}

extension String: PartialNamedPatternMatcher { }
extension Int: PartialNamedPatternMatcher { }
extension Double: PartialNamedPatternMatcher { }
extension Bool: PartialNamedPatternMatcher { }

extension Sequence where Iterator.Element: PartialNamedPatternMatcher {
    /**
     Converts the receiver into a `PartialPatternMatcher` test that can be used in pattern matching
     
     - parameter name: The name to use if this tests has a successful match
     - returns: A new `PartialPatternMatcher` instance to be used in pattern matching
     */
    public func any(name: String) -> PartialPatternMatcher {
        return NamedSequencePatternMatcher(input: self, name: name)
    }
}

extension Sequence where Iterator.Element == PartialPatternMatcher {
    /**
     Converts a `Sequence` of _mixed_ and _unnamed_ `PartialPatternMatcher`s into 
     a single `PartialPatternMatcher` test that can be used in pattern matching
     
     The first matched found from left to right will be used
     
     - parameter name: The name to use if this tests has a successful match
     - returns: A new `PartialPatternMatcher` instance to be used in pattern matching
     */
    public func any(name: String) -> PartialPatternMatcher {
        return MixedNamedSequencePatternMatcher(input: self, name: name)
    }
}
