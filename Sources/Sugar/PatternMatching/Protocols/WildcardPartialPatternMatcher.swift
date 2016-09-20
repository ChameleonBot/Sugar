
/// An abstraction that represents a type that can be used to perform a wildcard pattern match test
public protocol WildcardPartialPatternMatcher {
    /// Returns a `PartialPatternMatcher` test that can be used to test this type
    static var any: PartialPatternMatcher { get }
}

extension String: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher(name: nil) { return $0 }
    }
}

extension Int: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher(name: nil) { return Int($0) }
    }
}

extension Double: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher(name: nil) { return Double($0) }
    }
}

extension Bool: WildcardPartialPatternMatcher {
    public static var any: PartialPatternMatcher {
        return ConversionPatternMatcher<Bool>(name: nil) { input in
            let input = input.lowercased()
            let truthy = ["true", "t", "yes", "y", "1"]
            let falsey = ["false", "f", "no", "n", "0"]
            if (truthy.contains(input)) { return true }
            if (falsey.contains(input)) { return false }
            return nil
        }
    }
}
