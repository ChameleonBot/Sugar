import Foundation

/// An abstraction that represents a type that can be used to perform a wildcard pattern match test
public protocol WildcardPartialPatternMatcher {
    /// Returns a `PartialPatternMatcher` test that can be used to test this type
    static var any: PartialPatternMatcher { get }
}

extension String: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher(greedy: true, required: false, name: nil) {
            return ConversionPatternMatch(value: $0, matched: $0)
        }
    }
}

extension Int: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher<Int>(greedy: false, required: false, name: nil) { value in
            guard
                let potential = value.components(separatedBy: " ").first,
                let value = Int(potential)
                else { return nil }
            
            return ConversionPatternMatch(value: value, matched: potential)
        }
    }
}

extension Double: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher<Double>(greedy: false, required: false, name: nil) { value in
            guard
                let potential = value.components(separatedBy: " ").first,
                let value = Double(potential)
                else { return nil }
            
            return ConversionPatternMatch(value: value, matched: potential)
        }
    }
}

extension Bool: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher<Bool>(greedy: false, required: false, name: nil) { value in
            guard
                let potential = value.components(separatedBy: " ").first?.lowercased()
                else { return nil }
            
            let truthy = ["true", "t", "yes", "y", "yep", "yup", "yeah", "yeh"]
            let falsey = ["false", "f", "no", "n", "nah", "nup", "nope"]
            if (truthy.contains(potential)) { return ConversionPatternMatch(value: true, matched: potential) }
            if (falsey.contains(potential)) { return ConversionPatternMatch(value: false, matched: potential) }
            return nil
        }
    }
}
