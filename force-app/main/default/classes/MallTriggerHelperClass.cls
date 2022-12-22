public class MallTriggerHelperClass {
    public static void updateCheckBox(Set<Id> mallIdSet){
        List<Shop__c> recordsToBeUpdated = new List<Shop__c>(); 
        List<Mall__c> mallList = [SELECT Id,Active_Mall__c,(SELECT Id,Active_Shop__c FROM Shops__r) 
                                   FROM Mall__c
                                   WHERE Id IN :mallIdSet];

        for(Mall__c mall : mallList){
            if(mall.Shops__r.size()>0){
                for(Shop__c shop : mall.Shops__r){
                    if(mall.Active_Mall__c == true){
                        shop.Active_Shop__c = true;
                        System.debug('&&^^%%');
                    }
                    else {
                        shop.Active_Shop__c = false;
                        System.debug('@@^false');
                    }
                    recordsToBeUpdated.add(shop);
                }
            }
        }
        if(recordsToBeUpdated.size()>0){
            update recordsToBeUpdated;
        }
    }

}