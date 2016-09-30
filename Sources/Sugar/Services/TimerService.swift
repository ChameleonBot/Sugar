import Foundation
import Bot

/**
 Provides a timer-eske service.
 Listens to the `ping` `RTMAPIEvent` as a way to track how much time has passed
 */
public final class TimerService {
    //MARK: - Properties
    private let id: String
    private let interval: TimeInterval
    private let closure: (Pong) throws -> Void
    private let storage: Storage
    
    //MARK: - Lifecycle
    public init(id: String, interval: TimeInterval, storage: Storage, dispatcher: SlackRTMEventDispatcher, closure: @escaping (Pong) throws -> Void) {
        self.id = id
        self.interval = interval
        self.closure = closure
        self.storage = storage
        dispatcher.onEvent(pong.self, handler: self.pongEvent)
    }
    
    //MARK: - Timer
    private func pongEvent(pong: Pong) throws {
        let lastExecuted: Int = self.storage.get(.in("Timers"), key: self.id, or: 0)
        guard (pong.timestamp - lastExecuted) >= Int(self.interval) else { return }
        
        try self.storage.set(.in("Timers"), key: self.id, value: pong.timestamp)
        try self.closure(pong)
    }
}

