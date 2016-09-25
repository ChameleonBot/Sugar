/**
 These are a set of optional operators to make constructing a `SlackMessage` made of lots of components a little more fluent
 Everything these operators do can be done with the `SlackMessage` object directly
 */

public func +(message: SlackMessage, value: SlackMessageSegment) -> SlackMessage {
    return message.add(segment: value)
}
