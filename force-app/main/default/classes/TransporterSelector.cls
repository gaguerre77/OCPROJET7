public class TransporterSelector {
    // Méthode pour récupérer le meilleur transporteur en fonction du prix
    public static List<Transporteur_Prix__c> getBestPriceCarriers(String shippingCountry) {
        try {
            // Requête pour obtenir le transporteur avec le meilleur prix
            return [
                SELECT Id, TransporteurId__c, Tarif__c, Delai_de_Livraison__c
                FROM Transporteur_Prix__c
                WHERE Pays__c = :shippingCountry
                ORDER BY Tarif__c ASC
                LIMIT 1
            ];
        } catch (Exception e) {
            System.debug('Erreur lors de la récupération du meilleur transporteur par prix: ' + e.getMessage());
            return new List<Transporteur_Prix__c>();
        }
    }

    // Méthode pour récupérer le meilleur transporteur en fonction du délai
    public static List<Transporteur_Prix__c> getBestDelayCarriers(String shippingCountry) {
        try {
            // Requête pour obtenir le transporteur avec le meilleur délai
            return [
                SELECT Id, TransporteurId__c, Tarif__c, Delai_de_Livraison__c
                FROM Transporteur_Prix__c
                WHERE Pays__c = :shippingCountry
                ORDER BY Delai_de_Livraison__c ASC
                LIMIT 1
            ];
        } catch (Exception e) {
            System.debug('Erreur lors de la récupération du meilleur transporteur par délai: ' + e.getMessage());
            return new List<Transporteur_Prix__c>();
        }
    }
}
