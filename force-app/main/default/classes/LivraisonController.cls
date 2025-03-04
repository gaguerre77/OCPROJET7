public with sharing class LivraisonController {
    // Méthode pour récupérer les livraisons
    @AuraEnabled(cacheable=true)
    public static List<Livraisons__c> getLivraisons() {
        return [SELECT Id, Order__c, Name, PaysDestination__c, Etat__c FROM Livraisons__c LIMIT 100];
    }

    // Méthode pour compléter une livraison avec le meilleur prix
    @AuraEnabled
    public static void completeLivraisonMeilleurPrix(Id livraisonId) {
        Livraisons__c livraison = [SELECT Id, Name, Etat__c FROM Livraisons__c WHERE Id = :livraisonId];
        if (livraison != null) {
            // Logique pour compléter la livraison avec le meilleur prix
            // Par exemple, mettre à jour un champ statut ou autre
            livraison.Etat__c = 'Complété - Meilleur Prix';
            update livraison;
        }
    }

    // Méthode pour compléter une livraison avec le meilleur délai
    @AuraEnabled
    public static void completeLivraisonMeilleurDelai(Id livraisonId) {
        Livraisons__c livraison = [SELECT Id, Name, Etat__c FROM Livraisons__c WHERE Id = :livraisonId];
        if (livraison != null) {
            // Logique pour compléter la livraison avec le meilleur délai
            // Par exemple, mettre à jour un champ statut ou autre
            livraison.Etat__c = 'Complété - Meilleur Délai';
            update livraison;
        }
    }
}

