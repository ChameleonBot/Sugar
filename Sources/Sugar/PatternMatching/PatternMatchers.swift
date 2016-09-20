import Common

/// An individual partial match obtained during a pattern match attempt
public struct PartialPatternMatch {
    /// The (optional) name to associated with this match
    public var name: String?
    
    /// The source `String` that was matched against
    public var matched: String
    
    /// The value that was matched, stored as its 'correct' type
    public var value: Any
}

/// The complete set of results obtained from a successful pattern match
public struct PatternMatchResult {
    public let partials: [PartialPatternMatch]
    
    init(partials: [PartialPatternMatch]) {
        self.partials = partials
    }
    
    /**
     Attempt to return a named value obtained from a pattern match
     
     - parameter named: The captured name used to lookup the value
     - returns: The value if it was captured and is of type `T`, otherwise `nil`
     */
    public func tryValue<T>(named: String) -> T? {
        return self.partials
            .filter { $0.name == named }
            .first?.value as? T
    }
    
    /**
     Return a named value obtained from a pattern match
     
     - parameter named: The captured name used to lookup the value
     - returns: The captured value of type `T`
     */
    public func value<T>(named: String) -> T {
        return self.tryValue(named: named)!
    }
}

extension String {
    /**
     Tests the receiver incrementally against a series of `PartialPatternMatcher` tests.
     
     Testing is performed from left to right and each test must succeed in order otherwise the whole test fails.
     
     Examples
     You can perform simple pattern matching:
     ```
     let source = "hello @botname"
     if let helloCommand = source.match(["hi", "hello", "hey"], slackBot.me) {
        // User said hello to the bot
     }
     ```
     
     or if you need to extract the values from the pattern:
     ```
     let source = "@botname give me a number between 0 and 42"
     if let command = source.match(slackBot.me, "give me a number between", Int.any(name: "first"), "and", Int.any(name: "second")) {
        let first: Int = command.value(name: "first")
        let second: Int = command.value(name: "second")
        
        //use Ints to get random number
     }
     ```
     
     - parameter pattern: A sequence of `PartialPatternMatcher`s used to test the receiver
     - parameter allowRemainder: When `false` there cannot be any leftover/untested data in the receiver otherwise the test will fail
     - returns: A new `PatternMatchResult` instance if all the tests pass, otherwise `nil`
     */
    public func match(_ pattern: PartialPatternMatcher..., allowRemainder: Bool = false) -> PatternMatchResult? {
        return performPatternMatch(input: self, pattern: pattern, allowRemainder: allowRemainder)
    }
    
    /**
     Returns wether or not the receiver is a match against the provided `PartialPatternMatcher` tests.
     
     Testing is performed from left to right and each test must succeed in order otherwise the whole test fails.
     
     Example:
     ```
     let source = "hello @botname"
     if source.matches(["hi", "hello", "hey"], slackBot.me) {
        // User said hello to the bot
     }
     ```
     
     - parameter pattern: A sequence of `PartialPatternMatcher`s used to test the receiver
     - parameter allowRemainder: When `false` there cannot be any leftover/untested data in the receiver otherwise the test will fail
     - returns: `true` if all the tests pass, otherwise `false`
     */
    public func matches(_ pattern: PartialPatternMatcher..., allowRemainder: Bool = false) -> Bool {
        return (performPatternMatch(input: self, pattern: pattern, allowRemainder: allowRemainder) != nil)
    }
}

func performPatternMatch(input: String, pattern: [PartialPatternMatcher], allowRemainder: Bool = false) -> PatternMatchResult? {
    var value = input
    var partials: [PartialPatternMatch] = []
    
    for item in pattern {
        guard let match = item.match(against: value) else { return nil }
        
        value = value.remove(prefix: match.matched)
        partials.append(match)
    }
    
    if (!value.isEmpty && !allowRemainder) { return nil }
    return PatternMatchResult(partials: partials)
}
