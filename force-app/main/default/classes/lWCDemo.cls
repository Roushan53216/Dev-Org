public with sharing class lWCDemo {

    @AuraEnabled(cacheable = true)
    public static List<Contact> getContact(){
        try {
            return [SELECT ID,Name,FirstName,LastName,Phone,Email FROM Contact LIMIT 3];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    @AuraEnabled
    public static List<Account> getAccount(){
        try {
            return [SELECT ID,Name,Active__c,Rating,SLAExpirationDate__c FROM Account LIMIT 15];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage()); 
        }
    }

    @AuraEnabled
    public static List<Contact> getAccountFromKeyword(String searchKeyword){
        try {
            return [SELECT ID,Name,FirstName,LastName,Phone,Email FROM Contact WHERE Name LIKE :searchKeyword + '%' LIMIT 3 ]; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}