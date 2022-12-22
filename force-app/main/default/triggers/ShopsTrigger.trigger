trigger ShopsTrigger on Shop__c (after insert,after update) {
    Set<Id> mallIdSet = new Set<Id>();
    Set<Id> shopIdSet = new Set<Id>();
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(Shop__c shop : Trigger.new){
                if(shop.Mallid__c != null){
                    mallIdSet.add(shop.Mallid__c);
                    shopIdSet.add(shop.Id);
                }
            }
        }
        if(Trigger.isUpdate){
            if(ShopTriggerHelperClass.isFirstTime){
                ShopTriggerHelperClass.isFirstTime = false;
                for(Shop__c shop : Trigger.old){
                    if(shop.Mallid__c != null ){
                        mallIdSet.add(shop.Mallid__c);  
                        shopIdSet.add(shop.Id);
                    }
                    if(shop.Mallid__c != Trigger.oldMap.get(shop.Id).Mallid__c){
                        mallIdSet.add(shop.Mallid__c);
                        shopIdSet.add(shop.Id);
                    }
                }
            }
        }
        ShopTriggerHelperClass.updateCheckBox(mallIdSet,shopIdSet); 
    }
}