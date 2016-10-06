import Bot

public protocol SlackMessageService: SlackRTMEventService {
    var allowedSubTypes: [MessageSubType] { get }
    
    func messageEvent(slackBot: SlackBot, webApi: WebAPI, message: MessageDecorator, previous: MessageDecorator?) throws
}

extension SlackMessageService {
    public var allowedSubTypes: [MessageSubType] { return [.me_message] }
    
    public func configureMessageEvent(slackBot: SlackBot, webApi: WebAPI, dispatcher: SlackRTMEventDispatcher) {
        dispatcher.onEvent(message.self) { data in
            if let subtype = data.message.subtype, !self.allowedSubTypes.contains(subtype) {
                return
            }
            
            try self.messageEvent(
                slackBot: slackBot,
                webApi: webApi,
                message: data.message.makeDecorator(slackModels: slackBot.currentSlackModelData),
                previous: data.previous?.makeDecorator(slackModels: slackBot.currentSlackModelData)
            )
        }
    }
    
    public func configureEvents(slackBot: SlackBot, webApi: WebAPI, dispatcher: SlackRTMEventDispatcher) {
        self.configureMessageEvent(slackBot: slackBot, webApi: webApi, dispatcher: dispatcher)
    }
}
