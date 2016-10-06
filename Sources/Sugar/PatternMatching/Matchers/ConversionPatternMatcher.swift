
public struct ConversionPatternMatch<T> {
    let value: T
    let matched: String
}

/// A matcher that attempts to convert a string into another type using the provided conversion function
public struct ConversionPatternMatcher<T>: PartialPatternMatcher {
    public let isGreedy: Bool
    public let isRequired: Bool
    
    let name: String?
    let typeConvertor: (String) -> ConversionPatternMatch<T>?
    
    init(greedy: Bool, required: Bool, name: String?, typeConvertor: @escaping (String) -> ConversionPatternMatch<T>?) {
        self.isGreedy = greedy
        self.isRequired = required
        
        self.name = name
        self.typeConvertor = typeConvertor
    }
    
    public func match(against string: String) -> PartialPatternMatch? {
        guard let match = self.typeConvertor(string) else { return nil }
        
        return PartialPatternMatch(
            name: self.name,
            matched: string.substring(to: String(describing: match.matched).endIndex),
            value: match.value
        )
    }
    
    public var matchDescription: String {
        if !self.isRequired { return "" }
        
        let string = name ?? "\(T.self)"
        return "<\(string)>"
    }
}
