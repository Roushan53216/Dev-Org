@isTest
public class FutureMethodExampleTest {
    public static testMethod void test(){
        Account acc = new Account(Name = 'TestClass');
        insert acc;
        
        Contact con = new Contact(LastName = 'CheckTest',AccountId=acc.Id);
        insert con;
        
        Set<Id> setId = new Set<Id>();
        setId.add(acc.Id);
        Test.startTest();
        FutureMethodExample.futureMethod(setId);
        Test.stopTest();
        Account ac = [SELECT Name,Number_Of_Contacts__c From Account WHERE Id= :acc.Id LIMIT 1];
        System.assertEquals(Integer.valueOf(ac.Number_Of_Contacts__c), 1);
    }
    
}