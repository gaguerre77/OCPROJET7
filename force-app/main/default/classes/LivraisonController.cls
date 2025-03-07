public with sharing class LivraisonController {
    @AuraEnabled(cacheable=true)
    // CONTROLLER DES VALIDATIONS D EXPEDITIONS
    
    public static List<Livraisons__c> getLivraisons() {
        return LivraisonService.getLivraisons();
    }

    @AuraEnabled
    public static void completeLivraisonMeilleurPrix(Id livraisonId) {
        CompleteLivraisonMeilleurPrixService.completeLivraisonMeilleurPrix(livraisonId);
    }

    @AuraEnabled
    public static void completeLivraisonMeilleurDelai(Id livraisonId) {
        CompleteLivraisonMeilleurDelaiService.completeLivraisonMeilleurDelai(livraisonId);
    }
}
