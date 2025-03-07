public with sharing class LivraisonService {
    @AuraEnabled(cacheable=true)
    public static List<Livraisons__c> getLivraisons() {
        return [SELECT Id, Order__c, Name, PaysDestination__c, Etat__c FROM Livraisons__c LIMIT 100];
    }
}
