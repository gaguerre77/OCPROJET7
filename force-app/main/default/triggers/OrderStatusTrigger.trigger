trigger OrderStatusTrigger on Order (after update) {
    // List to hold Livraisons__c records to be inserted
    List<Livraisons__c> livraisonsToInsert = new List<Livraisons__c>();

    // Map to hold Account information for quick access
    Map<Id, Account> accountMap = new Map<Id, Account>();

    // Collect all Account IDs from the updated Orders
    for (Order o : Trigger.new) {
        if (o.Status == 'Activated' && Trigger.oldMap.get(o.Id).Status == 'Draft') {
            accountMap.put(o.AccountId, null);
        }
    }

    // Query Accounts in bulk
    if (!accountMap.isEmpty()) {
        for (Account acc : [SELECT Id, Professionnel__c, Particulier__c FROM Account WHERE Id IN :accountMap.keySet()]) {
            accountMap.put(acc.Id, acc);
        }
    }

    // Process each updated Order
    for (Order o : Trigger.new) {
        if (o.Status == 'Activated' && Trigger.oldMap.get(o.Id).Status == 'Draft') {
            Account account = accountMap.get(o.AccountId);
            if (account != null) {
                if ((account.Professionnel__c && o.Nb_Child_Product__c > 5) ||
                    (account.Particulier__c && o.Nb_Child_Product__c > 3)) {

                    // Create a new Livraisons__c record
                    Livraisons__c livraison = new Livraisons__c();
                    livraison.Order__c = o.Id;
                    livraison.PaysDestination__c = o.ShippingCountry;
                    livraison.Etat__c = 'aexpedier';
                    livraison.Particulier__c = account.Particulier__c;
                    livraison.Professionnel__c = account.Professionnel__c;
                    livraisonsToInsert.add(livraison);

                    // Log the creation of Livraisons__c record
                    System.debug('Livraisons__c record created for Order ID: ' + o.Id);
                }
            }
        }
    }

    // Insert all Livraisons__c records in one DML operation
    if (!livraisonsToInsert.isEmpty()) {
        insert livraisonsToInsert;
    }
}
