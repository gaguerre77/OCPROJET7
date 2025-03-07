/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
public class TransporterSelectorTest {
    @IsTest
    static void testGetBestPriceCarriers() {
        // Créer des données de test
        List<Transporteur_Prix__c> testTransporteurs = new List<Transporteur_Prix__c>();
        for (Integer i = 0; i < 5; i++) {
            Transporteur_Prix__c transporteur = new Transporteur_Prix__c(
                Pays__c = 'France',
                Tarif__c = 100.0 + i,
                Delai_de_Livraison__c = 5 + i
            );
            testTransporteurs.add(transporteur);
        }
        insert testTransporteurs;

        // Appeler la méthode à tester
        List<Transporteur_Prix__c> result = TransporterSelector.getBestPriceCarriers('France');

        // Vérifier que le résultat est correct
        System.assertEquals(1, result.size(), 'Le nombre de transporteurs retournés est incorrect.');
        System.assertEquals(100.0, result[0].Tarif__c, 'Le tarif du transporteur retourné est incorrect.');
    }

    @IsTest
    static void testGetBestDelayCarriers() {
        // Créer des données de test
        List<Transporteur_Prix__c> testTransporteurs = new List<Transporteur_Prix__c>();
        for (Integer i = 0; i < 5; i++) {
            Transporteur_Prix__c transporteur = new Transporteur_Prix__c(
                Pays__c = 'France',
                Tarif__c = 100.0 + i,
                Delai_de_Livraison__c = 5 + i
            );
            testTransporteurs.add(transporteur);
        }
        insert testTransporteurs;

        // Appeler la méthode à tester
        List<Transporteur_Prix__c> result = TransporterSelector.getBestDelayCarriers('France');

        // Vérifier que le résultat est correct
        System.assertEquals(1, result.size(), 'Le nombre de transporteurs retournés est incorrect.');
        System.assertEquals(5, result[0].Delai_de_Livraison__c, 'Le délai de livraison du transporteur retourné est incorrect.');
    }

    @IsTest
    static void testGetBestPriceCarriersNoData() {
        // Appeler la méthode avec un pays sans transporteurs
        List<Transporteur_Prix__c> result = TransporterSelector.getBestPriceCarriers('PaysSansTransporteurs');

        // Vérifier que la liste est vide
        System.assertEquals(0, result.size(), 'La liste ne devrait pas contenir de transporteurs.');
    }
}
