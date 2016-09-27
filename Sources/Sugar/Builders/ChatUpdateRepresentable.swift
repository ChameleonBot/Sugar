import Models
import WebAPI

/// An abstraction representing something that can be turned into a `ChatUpdate` method
public protocol ChatUpdateRepresentable {
    /**
     Convert this object into a `ChatUpdate`
     
     - parameter to: The original `Message` this `ChatUpdate` will replace
     - returns: A new `ChatUpdate` instance
     */
    func makeChatUpdate(to original: Message) throws -> ChatUpdate
}
