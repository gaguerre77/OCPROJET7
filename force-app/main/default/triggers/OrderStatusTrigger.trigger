trigger OrderStatusTrigger on Order (after update) {
    List<Livraisons__c> livraisonsToInsert = new List<Livraisons__c>();
    Map<Id, Account> accountMap = new Map<Id, Account>();

    // Collect Account IDs
    for (Order o : Trigger.new) {
        if (o.Status == 'Activated' && Trigger.oldMap.get(o.Id).Status == 'Draft') {
            accountMap.put(o.AccountId, null);
        }
    }

    // Query Accounts using the AccountSelector method
    if (!accountMap.isEmpty()) {
        accountMap = AccountSelector.getAccountsByIds(accountMap.keySet());
    }

    // Process Orders
    for (Order o : Trigger.new) {
        if (o.Status == 'Activated' && Trigger.oldMap.get(o.Id).Status == 'Draft') {
            Account account = accountMap.get(o.AccountId);
            if (account != null && o.ShippingCountry != null) {
                if ((account.Professionnel__c && o.Nb_Child_Product__c > 5) ||
                    (account.Particulier__c && o.Nb_Child_Product__c > 3)) {

                    // Utilisation des méthodes de la classe utilitaire
                    List<Transporteur_Prix__c> bestPriceCarriers = TransporterSelector.getBestPriceCarriers(o.ShippingCountry);
                    List<Transporteur_Prix__c> bestDelayCarriers = TransporterSelector.getBestDelayCarriers(o.ShippingCountry);

                    // Create Livraisons__c record
                    Livraisons__c livraison = new Livraisons__c();
                    livraison.Order__c = o.Id;
                    livraison.PaysDestination__c = o.ShippingCountry;
                    livraison.Etat__c = 'aexpedier';
                    livraison.Particulier__c = account.Particulier__c;
                    livraison.Professionnel__c = account.Professionnel__c;

                    // Set fields for best price carrier
                    if (!bestPriceCarriers.isEmpty()) {
                        Transporteur_Prix__c bestPriceCarrier = bestPriceCarriers[0];
                        livraison.TransporteurMeilleurPrix__c = bestPriceCarrier.TransporteurId__c;
                        livraison.MeilleurPrix__c = bestPriceCarrier.Tarif__c;
                        livraison.DelaiMeilleurPrix__c = bestPriceCarrier.Delai_de_Livraison__c;
                    }

                    // Set fields for best delay carrier
                    if (!bestDelayCarriers.isEmpty()) {
                        Transporteur_Prix__c bestDelayCarrier = bestDelayCarriers[0];
                        livraison.TransporteurMeilleurDelai__c = bestDelayCarrier.TransporteurId__c;
                        livraison.PrixMeilleurDelai__c = bestDelayCarrier.Tarif__c;
                        livraison.MeilleurDelai__c = bestDelayCarrier.Delai_de_Livraison__c;
                    }

                    livraisonsToInsert.add(livraison);
                    System.debug('Livraisons__c record created for Order ID: ' + o.Id);
                }
            }
        }
    }

    // Insert Livraisons__c records
    if (!livraisonsToInsert.isEmpty()) {
        insert livraisonsToInsert;
    }
}
