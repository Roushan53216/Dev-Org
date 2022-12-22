public with sharing class ShopTriggerHelperClass {
    public static Boolean isFirstTime = true;

    public static void updateCheckBox(Set<Id> mallIdSet,Set<Id> shopIdSet){
        List<Mall__c> recordsToBeUpdated = new List<Mall__c>();
        Map<Id,Mall__c> mallMap = new Map<Id,Mall__c>();
        List<Mall__c> mallList = [SELECT Id,Active_Mall__c,(SELECT Id,Active_Shop__c FROM Shops__r WHERE Id IN: shopIdSet) 
                                   FROM Mall__c
                                   WHERE Id IN :mallIdSet];
        
        for(Mall__c mall : mallList){
            for(Shop__c shop : mall.Shops__r){
                if(shop.Active_Shop__c == true){
                    mall.Active_Mall__c = true;
                    System.debug('$$True');
                }
                else{
                    mall.Active_Mall__c = false;
                    System.debug('%%false'); 

                }
                recordsToBeUpdated.add(mall);
            }
        }
        mallMap.putAll(recordsToBeUpdated);
        if(recordsToBeUpdated.size() > 0){
            update mallMap.values();
        }

    }

}