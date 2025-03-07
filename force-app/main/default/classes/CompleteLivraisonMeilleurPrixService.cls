public with sharing class CompleteLivraisonMeilleurPrixService {
    @AuraEnabled
    public static void completeLivraisonMeilleurPrix(Id livraisonId) {
        Livraisons__c livraison = [
            SELECT Id, Name, Etat__c, TransporteurMeilleurPrix__c, MeilleurPrix__c, DelaiMeilleurPrix__c
            FROM Livraisons__c
            WHERE Id = :livraisonId
        ];

        if (livraison != null && livraison.Etat__c != 'envoye') {
            if (livraison.TransporteurMeilleurPrix__c != null && livraison.MeilleurPrix__c != null && livraison.DelaiMeilleurPrix__c != null) {
                livraison.TransporteurChoisi__c = livraison.TransporteurMeilleurPrix__c;
                livraison.TarifApplique__c = livraison.MeilleurPrix__c;
                livraison.DelaiApplique__c = livraison.DelaiMeilleurPrix__c;
                livraison.Etat__c = 'envoye';

                update livraison;
                System.debug('Livraison complétée avec le meilleur prix et envoyée : ' + livraison.Name);
            } else {
                throw new AuraHandledException('Les informations nécessaires pour compléter la livraison avec le meilleur prix ne sont pas disponibles.');
            }
        } else {
            throw new AuraHandledException('La livraison est déjà envoyée ou introuvable.');
        }
    }
}
