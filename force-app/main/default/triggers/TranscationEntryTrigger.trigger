trigger TranscationEntryTrigger on Transcation_Entry__c ( after insert, after update, after delete, after undelete) {

    Set<Id> contactId = new Set<Id>();
    if(Trigger.isAfter){
        /*for(Transcation_Entry__c trans : Trigger.New){
            contactId.add(trans.Contact__c);
        }*/
        //TransactionEntryTriggerHelper.checkAmountBeforeDebit(Trigger.New);
        TransactionEntryTriggerHelper.updateAmount(Trigger.New);
       

    }
    

     /*List<Contact> conList = [SELECT Id,Available_Balance__c,(SELECT ID,Amount__c,Type__c FROM Trantaction_Entries__r ) 
                                FROM Contact 
                                WHERE Id IN :contactId]; 

        for(Contact con : conList){
            //double amount = 0;
            for(Transcation_Entry__c trans :con.Trantaction_Entries__r){
                if(trans.Type__c == 'Credit'){
                    //amount = amount + trans.Amount__c;
                    con.Available_Balance__c += trans.Amount__c;
                    System.debug('=====>>>>> '+ trans.Amount__c);
                }
                else if(trans.Type__c == 'Debit'){
                    con.Available_Balance__c -= trans.Amount__c;
                    System.debug('=====>>>>>Debit  '+ trans.Amount__c);
                }
            }
            contactToBeUpdateed.add(con);
        }

        if(contactToBeUpdateed.size()>0){
            update contactToBeUpdateed;
        }*/
}