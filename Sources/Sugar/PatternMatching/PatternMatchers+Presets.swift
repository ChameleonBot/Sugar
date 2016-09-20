private let _Greetings = ["hey", "hello", "hi"]

public let Greeting = _Greetings.any()
public func Greeting(name: String) -> PartialPatternMatcher {
    return _Greetings.any(name: name)
}
