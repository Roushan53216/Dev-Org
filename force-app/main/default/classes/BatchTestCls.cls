@isTest
public class BatchTestCls {
	
    @isTest
    static void unitTest1(){
        List<Account> accList = new List<Account>();
        for(Integer i=1;i<=5;i++){
            Account acc = new Account();
            acc.Name = 'Test' + i;
            acc.Batch_Test__c = 'Not Verified';
            accList.add(acc);
        }
        insert accList;
        
        Test.startTest();
        BatchToTestTestClass bcd = new BatchToTestTestClass();
        Id batchId = Database.executeBatch(bcd);
        
        Test.stopTest();
        List<Account> acc = [SELECT id,Name FROM ACCOUNT Where Batch_Test__c = 'Update Verified'];
        System.assertEquals(5, acc.size());
        
    }
    
}