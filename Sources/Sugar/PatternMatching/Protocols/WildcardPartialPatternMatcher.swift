import Foundation

/// An abstraction that represents a type that can be used to perform a wildcard pattern match test
public protocol WildcardPartialPatternMatcher {
    /// Returns a `PartialPatternMatcher` test that can be used to test this type
    static var any: PartialPatternMatcher { get }
}

extension String: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher(greedy: true, required: false, name: nil) { return $0 }
    }
}

extension Int: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher<Int>(greedy: false, required: false, name: nil) { value in
            guard
                let potential = value.components(separatedBy: " ").first
                else { return nil }
            
            return Int(potential)
        }
    }
}

extension Double: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher<Double>(greedy: false, required: false, name: nil) { value in
            guard
                let potential = value.components(separatedBy: " ").first
                else { return nil }
            
            return Double(potential)
        }
    }
}

extension Bool: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher<Bool>(greedy: false, required: false, name: nil) { value in
            guard
                let potential = value.components(separatedBy: " ").first?.lowercased()
                else { return nil }
            
            let truthy = ["true", "t", "yes", "y", "1"]
            let falsey = ["false", "f", "no", "n", "0"]
            if (truthy.contains(potential)) { return true }
            if (falsey.contains(potential)) { return false }
            return nil
        }
    }
}
