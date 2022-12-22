public with sharing class TransactionEntryTriggerHelper {


    public static void updateAmount(List<Transcation_Entry__c> transactionEntries ){
        List<Contact> contactToBeUpdateed = new List<Contact>();
        Set<Id> contactId = new Set<Id>();
        for(Transcation_Entry__c trans : transactionEntries){
            contactId.add(trans.Contact__c);
        }

        List<Contact> conList = [SELECT Id,Available_Balance__c,(SELECT ID,Amount__c,Type__c FROM Trantaction_Entries__r ) 
                                FROM Contact 
                                WHERE Id IN :contactId]; 

        for(Contact con : conList){
            con.Available_Balance__c = 0;
            for(Transcation_Entry__c trans :con.Trantaction_Entries__r){
                if(trans.Type__c == 'Credit'){
                    con.Available_Balance__c += trans.Amount__c;
                }
                else {
                    con.Available_Balance__c -= trans.Amount__c;
                    
                }
            }
            contactToBeUpdateed.add(con);
        }

        if(contactToBeUpdateed.size()>0){
            update contactToBeUpdateed;
        }

    }
    public static void sendEmailAfterTransaction(List<Transcation_Entry__c> transactionEntries){
        
        Set<Id> contactId = new Set<Id>();
        List<String> contactEmalList = new List<String>();
        for(Transcation_Entry__c trans : transactionEntries){
            contactId.add(trans.Contact__c);
        }
        List<Contact> contactList = [SELECT Id,Email,Available_Balance__c From Contact WHERE Id IN :contactId];

        for(Contact con : contactList){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();       
            message.toAddresses = new String[]{con.Email} ;
            message.subject = 'Subject Test Message';
            message.plainTextBody = ' Your A/c XXXXX is debited by Rs. '+con.Available_Balance__c +'on '+System.Today()+' . Available '+ 'Bal: Rs. '+con.Available_Balance__c; 
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }

    }

    

}