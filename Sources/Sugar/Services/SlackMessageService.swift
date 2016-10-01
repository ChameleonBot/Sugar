import Bot

open class SlackMessageService: SlackRTMEventService {
    open var allowedSubTypes: [MessageSubType] { return [.me_message] }
    
    public init() { }
    
    open func configureEvents(slackBot: SlackBot, webApi: WebAPI, dispatcher: SlackRTMEventDispatcher) {
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
    
    open func messageEvent(slackBot: SlackBot, webApi: WebAPI, message: MessageDecorator, previous: MessageDecorator?) throws {
        //Override...
    }
}
