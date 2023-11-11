trigger ContactTrigger on Contact (after insert, after update) {
    // Validate Number of Contacts
	ContactTriggerHandler.validateNumberOfContacts(Trigger.new);
}