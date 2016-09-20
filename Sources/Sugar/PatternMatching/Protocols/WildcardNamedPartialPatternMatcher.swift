
/// An abstraction that represents a type that can be used to perform a wildcard pattern match test
public protocol WildcardNamedPartialPatternMatcher {
    /**
     Returns a test used to see if the input is of this type
     
     - parameter name: The name to use if this test has a successful match
     - returns: A `PartialPatternMatcher` used to see if the input is of this type
     */
    static func any(name: String) -> PartialPatternMatcher
}

extension WildcardNamedPartialPatternMatcher where Self: WildcardPartialPatternMatcher {
    public static func any(name: String) -> PartialPatternMatcher {
        return ConversionPatternMatcher<Self>(greedy: self.any.isGreedy, required: true, name: name) { value in
            guard let matcher = self.any.match(against: value) else { return nil }
            return matcher.value as? Self
        }
    }
}

extension String: WildcardNamedPartialPatternMatcher { }
extension Int: WildcardNamedPartialPatternMatcher { }
extension Double: WildcardNamedPartialPatternMatcher { }
extension Bool: WildcardNamedPartialPatternMatcher { }
