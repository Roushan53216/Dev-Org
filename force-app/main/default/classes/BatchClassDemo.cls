global class BatchClassDemo implements Database.Batchable<sObject>,Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Batch_Test__c FROM Account]);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
        for(Account a : accList){
            a.Batch_Test__c = 'Update Verified';
        }
        update accList;
    }
    
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage sinMail = new messaging.SingleEmailMessage();
        String[] toAddress = new String[]{'roushankumar9536@gmail.com','rishabnirwal.123@gmail.com'};
        sinMail.setToAddresses(toAddress);
        sinMail.setSubject('Batch Job Done');
        sinMail.setPlainTextBody('Hi, Job Has Been Done');
        Messaging.sendEmail(new messaging.SingleEmailMessage[]{sinMail});
    }
    
    global void execute(SchedulableContext sc){
        BatchClassDemo bcd = new BatchClassDemo();
        Database.executebatch(bcd); 
    }
}