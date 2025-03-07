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
public class LivraisonServiceTest {
    @IsTest
    static void testGetLivraisons() {
        // Créer des données de test
        List<Livraisons__c> testLivraisons = new List<Livraisons__c>();
        for (Integer i = 0; i < 5; i++) {
            Livraisons__c livraison = new Livraisons__c(
                Name = 'Livraison Test ' + i,
                PaysDestination__c = 'France',
                Etat__c = 'aexpedier'
            );
            testLivraisons.add(livraison);
        }
        insert testLivraisons;

        // Appeler la méthode à tester
        List<Livraisons__c> result = LivraisonService.getLivraisons();

        // Vérifier que les résultats sont corrects
        System.assertEquals(5, result.size(), 'Le nombre de livraisons retournées est incorrect.');
        for (Livraisons__c livraison : result) {
            System.assertNotEquals(null, livraison.Id, 'L\'ID de la livraison ne doit pas être nul.');
        }
    }
}
