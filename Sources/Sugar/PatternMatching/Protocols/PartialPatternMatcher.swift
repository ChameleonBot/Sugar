
/// An abstraction that represents a type that can be used to perform a pattern match test
public protocol PartialPatternMatcher {
    /**
     Tests a `String` against this `PartialNamedPatternMatcher` instance
     
     - parameter against: The `String` to attempt to find a partial match in
     - returns: A new `PartialPatternMatch` instance if matching was successful, otherwise `nil`
     */
    func match(against string: String) -> PartialPatternMatch?
    
    /// Human readable representation of this portion of the pattern
    var matchDescription: String { get }
    
    /// When `true` this instance can match against an undefined amount of the input `String`
    var isGreedy: Bool { get }
    
    /// When `true` if this instance does _not_ match, the whole match fails. This is the default
    var isRequired: Bool { get }
}

extension PartialPatternMatcher {
    public func match(against string: String) -> PartialPatternMatch? {
        return DefaultPatternMatcher(input: self, name: nil).match(against: string)
    }
    
    public var matchDescription: String {
        return DefaultPatternMatcher(input: self, name: nil).matchDescription
    }
    
    public var isGreedy: Bool { return false }
    
    public var isRequired: Bool { return true }
}

extension String: PartialPatternMatcher {
    /**
     Attempt to match this `String`s value, _or_ nothing
     
     - returns: A new `PartialPatternMatcher` instance to be used in pattern matching
     */
    public var orNone: PartialPatternMatcher {
        return [self].anyOrNone
    }
}
extension Int: PartialPatternMatcher { }
extension Double: PartialPatternMatcher { }
extension Bool: PartialPatternMatcher { }

extension Sequence where Iterator.Element: PartialPatternMatcher {
    /**
     Converts the receiver into a `PartialPatternMatcher` test that can be used in pattern matching
     
     - returns: A new `PartialPatternMatcher` instance to be used in pattern matching
     */
    public var any: PartialPatternMatcher {
        return SequencePatternMatcher(input: self)
    }
}

extension Sequence where Iterator.Element: PartialPatternMatcher, Iterator.Element == String {
    /**
     Converts the receiver into a `PartialPatternMatcher` test that can be used in pattern matching
     It will attempt to match only items in the seqeunce, _or_ nothing
     
     - returns: A new `PartialPatternMatcher` instance to be used in pattern matching
     */
    public var anyOrNone: PartialPatternMatcher {
        var values = Set<String>(self)
        values.remove("")
        return SequencePatternMatcher(input: values + [""])
    }
}
