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
public class OrderStatusTriggerTest {
    @IsTest
    static void testOrderActivation() {
        // Créer un compte de test
        Account testAccount = new Account(
            Name = 'Compte Test',
            Professionnel__c = true,
            Particulier__c = false
        );
        insert testAccount;

        // Créer un produit de test
        Product2 testProduct = new Product2(
            Name = 'Produit Test',
            ProductCode = 'TEST123',
            IsActive = true
        );
        insert testProduct;

        // Créer une entrée de carnet de prix pour le produit
        PricebookEntry testPricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProduct.Id,
            UnitPrice = 10.0,
            IsActive = true
        );
        insert testPricebookEntry;

        // Créer une commande de test avec le champ EffectiveDate
        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            ShippingCountry = 'France',
            Pricebook2Id = Test.getStandardPricebookId(), // Utiliser l'ID du carnet de prix standard
            EffectiveDate = Date.today() // Ajouter le champ EffectiveDate
        );
        insert testOrder;

        // Ajouter des produits enfants pour influencer le champ calculé
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i < 6; i++) {
            OrderItem item = new OrderItem(
                OrderId = testOrder.Id,
                PricebookEntryId = testPricebookEntry.Id, // Utiliser l'ID de l'entrée de carnet de prix créée
                Quantity = 1,
                UnitPrice = 10.0
            );
            orderItems.add(item);
        }
        insert orderItems;

        // Créer un transporteur de test
        Transporteur_Prix__c testTransporteur = new Transporteur_Prix__c(
            Pays__c = 'France',
            Tarif__c = 100.0,
            Delai_de_Livraison__c = 5
        );
        insert testTransporteur;

        // Mettre à jour la commande pour déclencher le déclencheur
        Test.startTest();
        testOrder.Status = 'Activated';
        update testOrder;
        Test.stopTest();

        // Vérifier qu'un enregistrement Livraisons__c a été créé
        List<Livraisons__c> livraisons = [SELECT Id FROM Livraisons__c WHERE Order__c = :testOrder.Id];
        System.assertEquals(1, livraisons.size(), 'Un enregistrement Livraisons__c aurait dû être créé.');
    }

    @IsTest
    static void testOrderActivationNoLivraison() {
        // Créer un compte de test
        Account testAccount = new Account(
            Name = 'Compte Test',
            Professionnel__c = true,
            Particulier__c = false
        );
        insert testAccount;

        // Créer un produit de test
        Product2 testProduct = new Product2(
            Name = 'Produit Test',
            ProductCode = 'TEST123',
            IsActive = true
        );
        insert testProduct;

        // Créer une entrée de carnet de prix pour le produit
        PricebookEntry testPricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProduct.Id,
            UnitPrice = 10.0,
            IsActive = true
        );
        insert testPricebookEntry;

        // Créer une commande de test avec le champ EffectiveDate
        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            ShippingCountry = 'France',
            Pricebook2Id = Test.getStandardPricebookId(), // Utiliser l'ID du carnet de prix standard
            EffectiveDate = Date.today() // Ajouter le champ EffectiveDate
        );
        insert testOrder;

        // Ajouter des produits enfants pour influencer le champ calculé
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i < 3; i++) {
            OrderItem item = new OrderItem(
                OrderId = testOrder.Id,
                PricebookEntryId = testPricebookEntry.Id, // Utiliser l'ID de l'entrée de carnet de prix créée
                Quantity = 1,
                UnitPrice = 10.0
            );
            orderItems.add(item);
        }
        insert orderItems;

        // Mettre à jour la commande pour déclencher le déclencheur
        Test.startTest();
        testOrder.Status = 'Activated';
        update testOrder;
        Test.stopTest();

        // Vérifier qu'aucun enregistrement Livraisons__c n'a été créé
        List<Livraisons__c> livraisons = [SELECT Id FROM Livraisons__c WHERE Order__c = :testOrder.Id];
        System.assertEquals(0, livraisons.size(), 'Aucun enregistrement Livraisons__c n\'aurait dû être créé.');
    }
}
