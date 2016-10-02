import Models
import Common

extension SlackMessageAttachmentBuilder {
    /// Add a field to the attachment
    public func field(short: Bool, title: String, value: String) {
        var fields = self.attachment.fields ?? []
        fields.append(MessageAttachmentField(title: title, value: value, short: short))
        self.attachment.fields = fields
    }
    
    /// Retrieve a field by name
    public func field(titled title: String) -> MessageAttachmentField? {
        guard let field = (self.attachment.fields ?? []).filter({ $0.title == title }).first else { return nil }
        return field
    }
    
    /// Update an existing field if it can be found
    public func updateField(titled title: String, builder: (inout MessageAttachmentField) -> Void) {
        guard var field = self.field(titled: title) else { return }
        
        builder(&field)
        
        self.attachment.fields = self.attachment.fields?
            .replaceFirst(
                matching: { $0.title == title },
                with: field
        )
    }
    
    /**
     Update or add a field with a given name
     
     If the field exists it will be provided for changes, otherwise a new one will be created
     
     - Note: newly created fields will have the given title, no value and will _not_ be short by default
     */
    public func updateOrAddField(titled title: String, builder: (inout MessageAttachmentField) -> Void) {
        if self.field(titled: title) != nil {
            self.updateField(titled: title, builder: builder)
            
        } else {
            var field = MessageAttachmentField(title: title, value: "", short: false)
            builder(&field)
            self.field(short: field.short, title: field.title, value: field.value)
        }
    }
}
