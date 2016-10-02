import Models

public class SlackMessageAttachmentBuilder {
    //MARK: - Static 
    private static let DefaultAttachment = MessageAttachment(
        fallback: "", color: nil, pretext: nil,
        author_name: nil, author_link: nil, author_icon: nil,
        title: nil, title_link: nil,
        text: nil,
        fields: nil, actions: nil,
        from_url: nil, image_url: nil, thumb_url: nil,
        callback_id: nil, attachment_type: nil,
        mrkdwn_in: nil,
        footer: nil, footer_icon: nil,
        ts: nil
    )
    
    //MARK: - Internal Properties
    var attachment: MessageAttachment
    
    //MARK: - Lifecycle
    init(attachment: MessageAttachment = SlackMessageAttachmentBuilder.DefaultAttachment) {
        self.attachment = attachment
    }
    
    /// Attachment colour
    public func color(_ color: SlackColor) {
        self.attachment.color = color
    }
    
    /// Text that appears above the attachment block
    public func pretext(_ value: String, markdown: Bool = false) {
        self.attachment.pretext = value
        if (markdown && !(self.attachment.mrkdwn_in?.contains("pretext") ?? false)) {
            self.attachment.mrkdwn_in = (self.attachment.mrkdwn_in ?? []) + ["pretext"]
        }
    }
    
    /// Author information
    public func author(name: String? = nil, link: String? = nil, icon: String? = nil) {
        self.attachment.author_name = name
        self.attachment.author_link = link
        self.attachment.author_icon = icon
    }
    
    /// Attachment title
    public func title(name: String? = nil, link: String? = nil) {
        self.attachment.title = name
        self.attachment.title_link = link
    }
    
    /// Text that appears within the attachment
    public func text(_ value: String, markdown: Bool = false) {
        self.attachment.text = value
        if (markdown && !(self.attachment.mrkdwn_in?.contains("text") ?? false)) {
            self.attachment.mrkdwn_in = (self.attachment.mrkdwn_in ?? []) + ["text"]
        }
    }
    
    /// Attachment Image
    public func image(url: String) {
        self.attachment.image_url = url
    }
    
    /// Attachment thumbnail image
    public func thumbnail(url: String) {
        self.attachment.thumb_url = url
    }
    
    /// Footer for information
    public func footer(name: String, icon: String? = nil) {
        self.attachment.footer = name
        self.attachment.footer_icon = icon
    }
    
    /// Timestamp for attachment
    public func timestamp(_ value: Int) {
        self.attachment.ts = value
    }
    
    func makeMessageAttachment() -> MessageAttachment {
        return self.attachment
    }
}
