import Bot

extension SlackBot {
    /// Provides access to the `SlackBot`s `User` model
    public var me: User {
        let (botUser, _) = self.currentBotUserAndTeam()
        let models = self.currentSlackModelData()
        
        guard
            let me = models.users.filter({ $0.id == botUser.id || $0.bot_id == botUser.id }).first
            else { fatalError("This shouldn't happen") }
        
        return me
    }
    
    /**
     Find out if the provided `User` is the `SlackBot`s `User` model
     
     - parameter user: The `User` to test
     - returns: `true` if the provided `User`s represents this bot, otherwise `false`
     */
    public func isMe(user: User) -> Bool {
        let models = self.currentSlackModelData()
        
        let users = models.users + models.users.botUsers()
        return users.botUsers().contains { $0 == user }
    }
    
    /// Provides access to the current Slack teams admins
    public var admins: [User] {
        let models = self.currentSlackModelData()
        
        return models.users.filter { $0.is_admin }
    }
    
    /**
     Find out if the provided `User` is an admin in the current Slack team
     
     - parameter user: The `User` to test
     - returns: `true` if the provided `User` is an admin, otherwise `false`
     */
    public func isAdmin(user: User) -> Bool {
        return self.admins.contains(user)
    }
    
    /**
     Find a `SlackTargetType` with a given name or id
     
     - Note: names should be provided without any prefix (i.e. '#')
     - returns: A `SlackTargetType` if one was found, otherwise nil
     */
    public func target(nameOrId: String) -> SlackTargetType? {
        let models = self.currentSlackModelData()
        
        var targets: [SlackTargetType] = []
        targets.append(contentsOf: models.channels.flatMap({ $0 as SlackTargetType }))
        targets.append(contentsOf: models.groups.flatMap({ $0 as SlackTargetType }))
        targets.append(contentsOf: models.ims.flatMap({ $0 as SlackTargetType }))
        
        return targets
            .filter { $0.id == nameOrId || $0.name == nameOrId }
            .first
    }
}
