public class ContactTriggerHandler {
    
    // Method to validate the number of Contacts per Account
    public static void validateNumberOfContacts(List<Contact> contacts) {
        
        // Create a set to store Account IDs
        Set<Id> accountIds = new Set<Id>();

        // Populate the accountIds set with Account IDs from the Contact records
        for(Contact record : contacts) {
            accountIds.add(record.AccountId);
        }

        // Remove null values from the accountIds set (Contacts without an associated Account)
        accountIds.remove(null);

        // Create a map to store Account IDs and their corresponding Contact counts
        Map<Id, Integer> accountToContactCount = new Map<Id, Integer>();

        // Query to count Contacts per Account and filter Accounts with more than 10 Contacts
        for(AggregateResult aggResult : [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
            HAVING COUNT(Id) > 10
        ]) {
            accountToContactCount.put((Id)aggResult.get('AccountId'), (Integer)aggResult.get('contactCount'));
        }

        // Loop through the Contacts and add an error message if the Account exceeds the limit
        for(Contact record : contacts) {
            if(accountToContactCount.containsKey(record.AccountId) && accountToContactCount.get(record.AccountId) > 10) {
                record.addError('You cannot exceed 10 Contacts per Account.');
            }
        }
    }
    
}