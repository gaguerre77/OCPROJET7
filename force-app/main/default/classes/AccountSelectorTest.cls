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
public class AccountSelectorTest {
    @IsTest
    static void testGetAccountsByIds() {
        // Créer des comptes de test
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            Account acc = new Account(
                Name = 'Compte Test ' + i,
                Professionnel__c = true,  // Assurez-vous que c'est un Boolean
                Particulier__c = false // Assurez-vous que c'est un Boolean
            );
            testAccounts.add(acc);
        }
        insert testAccounts;

        // Récupérer les IDs des comptes créés
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : testAccounts) {
            accountIds.add(acc.Id);
        }

        // Appeler la méthode à tester
        Map<Id, Account> accountMap = AccountSelector.getAccountsByIds(accountIds);

        // Vérifier que les comptes ont été récupérés correctement
        System.assertEquals(5, accountMap.size(), 'Le nombre de comptes retournés est incorrect.');
        for (Id accountId : accountIds) {
            System.assertNotEquals(null, accountMap.get(accountId), 'Le compte avec l\'ID ' + accountId + ' n\'a pas été récupéré.');
        }
    }

    @IsTest
    static void testGetAccountsByIdsEmptySet() {
        // Appeler la méthode avec un ensemble vide
        Map<Id, Account> accountMap = AccountSelector.getAccountsByIds(new Set<Id>());

        // Vérifier que la map est vide
        System.assertEquals(0, accountMap.size(), 'La map ne devrait pas contenir de comptes.');
    }

    @IsTest
    static void testGetAccountsByIdsInvalidId() {
        // Utiliser un ID valide mais inexistant
        Set<Id> nonExistentAccountIds = new Set<Id>{Id.valueOf('001000000000000AAA')};
    
        // Appeler la méthode avec l'ID inexistant
        Map<Id, Account> accountMap = AccountSelector.getAccountsByIds(nonExistentAccountIds);
    
        // Vérifier que la map est vide
        System.assertEquals(0, accountMap.size(), 'La map ne devrait pas contenir de comptes pour un ID inexistant.');
    }
    
    
}
