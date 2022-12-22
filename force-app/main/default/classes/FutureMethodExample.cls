public class FutureMethodExample {
    
    @future
    public static void futureMethod(Set<Id> idSet){
        List<Account> accList = [SELECT Id,Name,Number_Of_Contacts__c,(SELECT Id,Name FROM Contacts) FROM Account WHERE Id IN :idSet];
        for(Account acc : accList){
            List<Contact> conList = acc.Contacts;
            acc.Number_Of_Contacts__c = conList.size();
        }
        update accList;
    }
}