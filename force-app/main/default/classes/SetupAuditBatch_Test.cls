@isTest
public with sharing class SetupAuditBatch_Test {

    @isTest
    static void testSetupAuditBatch(){
        Test.startTest();
        SetupAuditBatch setupAudit = new SetupAuditBatch();
        Id jobId = Database.executebatch(setupAudit,2000);
        Test.stopTest();
        System.AssertNotEquals(null,jobId);
    }

}