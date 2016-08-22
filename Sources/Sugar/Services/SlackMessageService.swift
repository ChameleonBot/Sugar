import Bot

public class SlackMessageService: SlackRTMEventService {
    public init() { }
    
    public func configureEvents(slackBot: SlackBot, webApi: WebAPI, dispatcher: SlackRTMEventDispatcher) {
        dispatcher.onEvent(MessageEvent.self) { data in
            try self.message(
                slackBot: slackBot,
                webApi: webApi,
                message: data.message.makeDecorator(slackModels: slackBot.currentSlackModelData),
                previous: data.previous?.makeDecorator(slackModels: slackBot.currentSlackModelData)
            )
        }
    }
    
    public func message(slackBot: SlackBot, webApi: WebAPI, message: MessageDecorator, previous: MessageDecorator?) throws {
        //Override...
    }
}
