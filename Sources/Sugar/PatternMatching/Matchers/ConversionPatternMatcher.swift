
/// A matcher that attempts to convert a string into another type using the provided conversion function
public struct ConversionPatternMatcher<T>: PartialPatternMatcher {
    let name: String?
    let typeConvertor: (String) -> T?
    
    init(name: String?, typeConvertor: @escaping (String) -> T?) {
        self.name = name
        self.typeConvertor = typeConvertor
    }
    
    public func match(against string: String) -> PartialPatternMatch? {
        guard let value = self.typeConvertor(string) else { return nil }
        
        return PartialPatternMatch(
            name: self.name,
            matched: string,
            value: value
        )
    }
}
