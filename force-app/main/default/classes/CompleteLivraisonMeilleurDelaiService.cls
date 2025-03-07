public with sharing class CompleteLivraisonMeilleurDelaiService {
    @AuraEnabled
    public static void completeLivraisonMeilleurDelai(Id livraisonId) {
        Livraisons__c livraison = [
            SELECT Id, Name, Etat__c, TransporteurMeilleurDelai__c, PrixMeilleurDelai__c, MeilleurDelai__c
            FROM Livraisons__c
            WHERE Id = :livraisonId
        ];

        if (livraison != null && livraison.Etat__c != 'envoye') {
            if (livraison.TransporteurMeilleurDelai__c != null && livraison.PrixMeilleurDelai__c != null && livraison.MeilleurDelai__c != null) {
                livraison.TransporteurChoisi__c = livraison.TransporteurMeilleurDelai__c;
                livraison.TarifApplique__c = livraison.PrixMeilleurDelai__c;
                livraison.DelaiApplique__c = livraison.MeilleurDelai__c;
                livraison.Etat__c = 'envoye';

                update livraison;
                System.debug('Livraison complétée avec le meilleur délai et envoyée : ' + livraison.Name);
            } else {
                throw new AuraHandledException('Les informations nécessaires pour compléter la livraison avec le meilleur délai ne sont pas disponibles.');
            }
        } else {
            throw new AuraHandledException('La livraison est déjà envoyée ou introuvable.');
        }
    }
}
