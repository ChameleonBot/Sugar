import Models
import WebAPI

class ActiveConversation<Segment: RawRepresentable, ConversationData> where Segment.RawValue: Equatable {
    //MARK: - Properties
    let user: User
    let target: SlackTargetType
    private var data: ConversationData?
    private let conversation: Conversation<Segment, ConversationData>
    private var currentSegment: Segment?
    private var currentMatch: PatternMatchResult?
    private var invalidResponse: Conversation<Segment, ConversationData>.InvalidResponseClosure?
    private var updatedData: Conversation<Segment, ConversationData>.UpdatedDataClosure?
    var segmentResult: ((ConversationSegmentResult<Segment>) -> Void)?
    
    //MARK: - Lifecycle
    init(
        conversation: Conversation<Segment, ConversationData>,
        user: User,
        target: SlackTargetType,
        starting: Segment,
        invalidResponse: Conversation<Segment, ConversationData>.InvalidResponseClosure?,
        initialData: ConversationData?,
        updatedData: Conversation<Segment, ConversationData>.UpdatedDataClosure?)
    {
        self.conversation = conversation
        self.user = user
        self.target = target
        self.data = initialData
        self.currentSegment = starting
        self.invalidResponse = invalidResponse
        self.updatedData = updatedData
    }
    
    //MARK: - Internal
    func start(match: PatternMatchResult, webApi: WebAPI) throws {
        guard let segment = self.currentSegment else { throw ConversationError.invalidState }
        try self.activate(segment: segment, match: match, webApi: webApi)
    }
    func handleMessage(message: MessageDecorator, webApi: WebAPI) throws {
        guard
            let user = message.sender, let target = message.target,
            user == user, target.id == target.id,
            let segment = self.currentSegment,
            let currentMatch = self.currentMatch
            else { return }
        
        let conversationSegment = try self.conversationSegment(segment)
        
        let trigger = conversationSegment.listenFor(user, target, currentMatch)
        
        if let match = message.text.match(pattern: trigger) {
            try self.execute(segment: conversationSegment, webApi: webApi, match: match)
            
        } else if let invalidResponse = self.invalidResponse {
            guard let response = try invalidResponse(user, target, message.text) else { return }
            try webApi.execute(response)
        }
    }
    
    //MARK: - Private
    private func activate(segment: Segment, match: PatternMatchResult, webApi: WebAPI) throws {
        let conversationSegment = try self.conversationSegment(segment)
        
        if let message = try conversationSegment.message(self.user, self.target, match) {
            try webApi.execute(message)
        }
        
        self.currentMatch = match
        self.currentSegment = segment
    }
    private func execute(segment: ConversationSegment<Segment, ConversationData>, webApi: WebAPI, match: PatternMatchResult) throws -> Void {
        
        let result = try segment.responder(self.user, self.target, match, self.data, { newData in
            self.data = newData
        })
        
        self.segmentResult?(result)
        
        switch result {
        case .next(let nextSegment):
            try self.activate(segment: nextSegment, match: match, webApi: webApi)
            
        case .complete(let message):
            self.currentSegment = nil
            self.currentMatch = nil
            
            if let message = message {
                try webApi.execute(message)
            }
            
            try self.updatedData?(self.user, self.target, self.data)
        }
    }
    private func conversationSegment(_ segment: Segment) throws -> ConversationSegment<Segment, ConversationData> {
        guard
            let conversationSegment = self.conversation.segments.first(where: { $0.name.rawValue == segment.rawValue })
            else { throw ConversationError.unknownSegment(value: segment.rawValue) }
        
        return conversationSegment
    }
}
