
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
public class CompleteLivraisonMeilleurPrixServiceTest {
    @IsTest
    static void testCompleteLivraisonMeilleurPrix() {
        // Créer une livraison de test
        Livraisons__c livraison = new Livraisons__c(
            Name = 'Livraison Test',
            PaysDestination__c = 'France',
            Etat__c = 'aexpedier',
            TransporteurMeilleurPrix__c = 1,  // Id externe du transporteur
            MeilleurPrix__c = 100.00,  
            DelaiMeilleurPrix__c = 5
        );
        insert livraison;

        // Appeler la méthode à tester
        Test.startTest();
        CompleteLivraisonMeilleurPrixService.completeLivraisonMeilleurPrix(livraison.Id);
        Test.stopTest();

        // Vérifier que la livraison a été mise à jour correctement
        livraison = [SELECT Id, Etat__c, TransporteurChoisi__c, TarifApplique__c, DelaiApplique__c FROM Livraisons__c WHERE Id = :livraison.Id];
        System.assertEquals('envoye', livraison.Etat__c, 'L\'état de la livraison n\'a pas été mis à jour correctement.');
        System.assertEquals(1, livraison.TransporteurChoisi__c, 'Le transporteur choisi n\'a pas été mis à jour correctement.'); // Assurez-vous que c'est un Integer
        System.assertEquals(100.00, livraison.TarifApplique__c, 'Le tarif appliqué n\'a pas été mis à jour correctement.'); // Assurez-vous que c'est un Decimal
        System.assertEquals(5, livraison.DelaiApplique__c, 'Le délai appliqué n\'a pas été mis à jour correctement.');
    }

    @IsTest
    static void testCompleteLivraisonMeilleurPrixException() {
        // Créer une livraison de test sans informations nécessaires
        Livraisons__c livraison = new Livraisons__c(
            Name = 'Livraison Test',
            PaysDestination__c = 'France',
            Etat__c = 'aexpedier'
        );
        insert livraison;
    
        // Vérifier que l'exception est levée
        try {
            Test.startTest();
            CompleteLivraisonMeilleurPrixService.completeLivraisonMeilleurPrix(livraison.Id);
            Test.stopTest();
            System.assert(false, 'Une exception aurait dû être levée.');
        } catch (Exception ex) {
            // Vérification du passage de la boucle avec un simple caractère
            System.assert(ex.getMessage().contains(' '), 'Le message d\'erreur n\'est pas correct.');
        }
    }
    
}
