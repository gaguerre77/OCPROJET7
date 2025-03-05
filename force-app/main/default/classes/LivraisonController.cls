public with sharing class LivraisonController {
    @AuraEnabled(cacheable=true)
    public static List<Livraisons__c> getLivraisons() {
        return [SELECT Id, Order__c, Name, PaysDestination__c, Etat__c FROM Livraisons__c LIMIT 100];
    }

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

    @AuraEnabled
    public static void completeLivraisonMeilleurDelai(Id livraisonId) {
        // Récupérer la livraison courante avec les champs nécessaires
        Livraisons__c livraison = [
            SELECT Id, Name, Etat__c, TransporteurMeilleurDelai__c, PrixMeilleurDelai__c, MeilleurDelai__c
            FROM Livraisons__c
            WHERE Id = :livraisonId
        ];

        if (livraison != null && livraison.Etat__c != 'envoye') {
            // Vérifier si les champs nécessaires sont définis
            if (livraison.TransporteurMeilleurDelai__c != null && livraison.PrixMeilleurDelai__c != null && livraison.MeilleurDelai__c != null) {
                // Mettre à jour les champs de la livraison
                livraison.TransporteurChoisi__c = livraison.TransporteurMeilleurDelai__c;
                livraison.TarifApplique__c = livraison.PrixMeilleurDelai__c;
                livraison.DelaiApplique__c = livraison.MeilleurDelai__c;
                livraison.Etat__c = 'envoye';

                // Mettre à jour l'enregistrement de livraison
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
