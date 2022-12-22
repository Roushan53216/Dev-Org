trigger ShopTrigger on Shop__c (after insert, after update, after delete, after undelete) {
    if(trigger.isAfter) {
        Set<Id> mallIdSet = new Set<Id>();
        if(trigger.isInsert || trigger.isundelete ) {
            for(Shop__c  shop: Trigger.new ) {
                if(shop.Mallid__c != null) {
                    mallIdSet.add(shop.Mallid__c);
                }
            }
        }
        if(trigger.isdelete ) {
            for(Shop__c  shop: Trigger.old ) {
                if(shop.Mallid__c != null) {
                    mallIdSet.add(shop.Mallid__c);
                }
            }
        }
        if(trigger.isUpdate ) {
            for(Shop__c  shop: Trigger.old ) {
                if(shop.Mallid__c != null && shop.Rent_Amount__c != trigger.oldMap.get(shop.Id).Rent_Amount__c) {
                    mallIdSet.add(shop.Mallid__c);
                } 
                if(shop.Mallid__c != trigger.oldMap.get(shop.Id).Mallid__c) {
                    mallIdSet.add(trigger.oldMap.get(shop.Id).Mallid__c);
                } 
            }
        } 

        if(mallIdSet.size() > 0) {
            updateTotalAmount(mallIdSet);
        }
    }

    private static void updateTotalAmount(Set<Id> mallsIdSet) {
        List<Mall__c> mallsList = new List<Mall__c>();
        for(Mall__c mall : [SELECT Id, Total_Rent_Amount__c, (SELECT Id,Name, Mallid__c, Rent_Amount__c From Shops__r)
                            FROM Mall__c WHERE Id IN: mallsIdSet]) {
                //Mall__c mall = New Mall__c(Id = mall.Id); 
                decimal totalAmount = 0;
                for(Shop__c shop : mall.Shops__r) {
                    if(shop.Rent_Amount__c != null) {
                        totalAmount += shop.Rent_Amount__c; 
                    }
                }
                mall.Total_Rent_Amount__c = totalAmount;
                mallsList.add(mall);
        }
        if(mallsList.size() > 0) {
            update mallsList;
        }
    }
}