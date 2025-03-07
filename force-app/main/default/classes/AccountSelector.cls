public class AccountSelector {
    // Méthode pour récupérer les comptes associés aux IDs fournis
    public static Map<Id, Account> getAccountsByIds(Set<Id> accountIds) {
        Map<Id, Account> accountMap = new Map<Id, Account>();
        try {
            for (Account acc : [SELECT Id, Professionnel__c, Particulier__c FROM Account WHERE Id IN :accountIds]) {
                accountMap.put(acc.Id, acc);
            }
        } catch (Exception e) {
            System.debug('Erreur lors de la récupération des comptes: ' + e.getMessage());
        }
        return accountMap;
    }
}
