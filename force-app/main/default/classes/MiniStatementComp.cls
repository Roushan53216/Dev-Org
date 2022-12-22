public with sharing class MiniStatementComp {

    @AuraEnabled
    public static list<Contact> fetchContacts(){        
            list<Contact> lstContact = new list<Contact>();
            for(Contact con : [SELECT id,name,email,phone,title FROM Contact LIMIT 5000]){
                lstContact.add(con);
            } 
            return lstContact;        
    }
    @AuraEnabled
    public static List<Transcation_Entry__c> fetchTransactions(String recordId){
        System.debug('====>>>>  '+recordId);
        List<Transcation_Entry__c> transactions = new List<Transcation_Entry__c>();
        try {
            for(Transcation_Entry__c trans : [SELECT Id,Name,Amount__c,Status__c,Transcation_Date__c,Type__c FROM Transcation_Entry__c Where Contact__c =:recordId]){
                transactions.add(trans);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return transactions;
    }

}