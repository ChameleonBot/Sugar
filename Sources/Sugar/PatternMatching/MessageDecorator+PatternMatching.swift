
extension MessageDecorator {
    /**
     Enables routing commands successfully pattern matched to a specific closure/function
     
     Testing is performed from left to right and each test must succeed in order otherwise the whole test fails.
     
     Examples
     You can perform simple pattern matching:
     ```
     //message.text: "hello @botname"
     
     message.routeText(
        to: sayHello,
        matching: ["hi", "hello", "hey"], slackBot.me
     )
     
     func sayHello(match: PatternMatchResult) {
        //say hello
     }
     ```
     
     or if you need to extract the values from the pattern:
     ```
     //message.text: "@botname give me a number between 0 and 42"
     
     message.routeText(
        to: deliverRandomNumber,
        matching: slackBot.me, "give me a number between", Int.any(name: "first"), "and", Int.any(name: "second")
     )
     
     func deliverRandomNumber(match: PatternMatchResult) {
        let first: Int = command.value(name: "first")
        let second: Int = command.value(name: "second")
        
        //deliver random number
     }
     ```
     
     - parameter to: The closure to execute upon matching the provided pattern
     - parameter allowRemainder: When `false` there cannot be any leftover/untested data in the receiver otherwise the test will fail
     - parameter matching: A sequence of `PartialPatternMatcher`s used to test the receiver
     */
    public func routeText(to closure: (PatternMatchResult) throws -> Void, allowingRemainder: Bool = false, matching pattern: PartialPatternMatcher...) rethrows {
        guard
            let match = performPatternMatch(input: self.text, pattern: pattern, allowRemainder: allowingRemainder)
            else { return }
        
        try closure(match)
    }
    
    /**
     Enables routing commands successfully pattern matched to a specific closure/function
     
     Testing is performed from left to right and each test must succeed in order otherwise the whole test fails.
     
     Examples
     You can perform simple pattern matching:
     ```
     //message.text: "hello @botname"
     
     message.routeText(
        to: sayHello,
        matching: ["hi", "hello", "hey"], slackBot.me
     )
     
     func sayHello(match: PatternMatchResult) {
        //say hello
     }
     ```
     
     or if you need to extract the values from the pattern:
     ```
     //message.text: "@botname give me a number between 0 and 42"
     
     message.routeText(
        to: deliverRandomNumber,
        matching: slackBot.me, "give me a number between", Int.any(name: "first"), "and", Int.any(name: "second")
     )
     
     func deliverRandomNumber(match: PatternMatchResult) {
        let first: Int = command.value(name: "first")
        let second: Int = command.value(name: "second")
     
        //deliver random number
     }
     ```
     
     - parameter to: The closure to execute upon matching the provided pattern
     - parameter allowRemainder: When `false` there cannot be any leftover/untested data in the receiver otherwise the test will fail
     - parameter matching: A sequence of `PartialPatternMatcher`s used to test the receiver
     */
    public func routeText(to closure: (PatternMatchResult) throws -> Void, allowingRemainder: Bool = false, matching pattern: [PartialPatternMatcher]) rethrows {
        guard
            let match = performPatternMatch(input: self.text, pattern: pattern, allowRemainder: allowingRemainder)
            else { return }
        
        try closure(match)
    }
}
