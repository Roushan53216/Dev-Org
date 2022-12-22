@isTest
public class AccountTriggerTest {
    static testMethod void validateAccountTrigger(){
        Account acc = new Account(Name='ABC',phone='732092');
        test.startTest();
        insert acc; 
        test.stopTest();
        acc = [SELECT Id,phone FROM Account where Id=:acc.Id ];
        System.assertEquals('732092', acc.phone);
    }
}