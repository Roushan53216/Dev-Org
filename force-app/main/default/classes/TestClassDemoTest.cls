@isTest
public class TestClassDemoTest {
    @isTest
    private static void test(){
        list<Account> accList = new List<Account>();
        for(Integer i=0;i<=200;i++){
            Account acc = new Account(Name = 'Test' + i,Batch_Test__c = 'Update Verified');
            accList.add(acc);
        }
        insert accList;
        Test.startTest();
        BatchToTestTestClass bc = new BatchToTestTestClass();
        Id batchId = Database.executeBatch(bc);
        Test.stopTest();
        List<Account> updatedAccList = [SELECT Id,Name,Batch_Test__c FROM Account];
        System.assertEquals(200, updatedAccList.size());
    }
}