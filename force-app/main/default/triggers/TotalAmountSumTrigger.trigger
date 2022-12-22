trigger TotalAmountSumTrigger on Shop__c (after insert,after update,after delete,after undelete) {
    List<String> shopId = new List<String>();
    List<Mall__c> recordToBeUpdated = new List<Mall__c>(); 
    // 
    if(Trigger.isInsert || Trigger.isUndelete){
        for(Shop__c s: Trigger.New){
            shopId.add(s.Mallid__c); 
        }
        
        
        List<Mall__c> mallList = [SELECT Id,Total_Rent_Amount__c,(SELECT Id,Name, Mallid__c, Rent_Amount__c From Shops__r)
                                  FROM Mall__c
                                  WHERE Id IN :shopId];
        //List<Shop__c> shopList = [SELECT Id,Name,Rent_Amount__c,Mallid__r.Id 
        //                          FROM Shop__c ];
        
        for(Mall__c mall : mallList){
            Id mallId = mall.Id;
            decimal total = 0;
            for(Shop__c shop : mall.Shops__r){
                if(mallId == shop.Mallid__c){
                    total = total + shop.Rent_Amount__c;
                }
            }
            mall.Total_Rent_Amount__c = total;
            recordToBeUpdated.add(mall);
        }
    }
    if(Trigger.isDelete ){
        List<Shop__c> deletedShopList = new List<Shop__c>();
        List<String> shopId = new List<String>();
        for(Shop__c s: Trigger.Old){
            shopId.add(s.Mallid__c);
            deletedShopList = Trigger.Old;
        }
        List<Mall__c> mallList = [SELECT Id,Total_Rent_Amount__c,(SELECT Id,Name From Shops__r)
                                  FROM Mall__c
                                  WHERE Id IN :shopId];
        
        for(Mall__c mall : mallList){
            Id mallId = mall.Id;
            decimal total = mall.Total_Rent_Amount__c;
            for(Shop__c shop : deletedShopList){
                if(mallId == shop.Mallid__c){
                    total = total - shop.Rent_Amount__c;
                }
            }
            mall.Total_Rent_Amount__c = total;
            
            recordToBeUpdated.add(mall);
        }
    }

    if(Trigger.isUpdate){
        Map<Id,Shop__c> oldShopMap = new Map<Id,Shop__c>();
        Map<Id,Shop__c> NewShopMap = new Map<Id,Shop__c>();
        List<Id> shopId = new List<Id>();
        for(Shop__c oldShop : Trigger.oldMap.Values()){ 
            oldShopMap = Trigger.oldMap;
            shopId.add(oldShop.Mallid__c);
        }
        for(Shop__c oldShop : Trigger.newMap.Values()){ 
            NewShopMap = Trigger.newMap;
            shopId.add(oldShop.Mallid__c);
        }
        Map<Id,Mall__c> mallMap = new Map<Id,Mall__c>([SELECT Id,Total_Rent_Amount__c,(SELECT Id,Mallid__c,Rent_Amount__c FROM Shops__r) FROM Mall__c WHERE id IN :shopId]);
        for(Shop__c shop : NewShopMap.Values()){
            Id oldShopsMallId = oldShopMap.get(shop.Id).Mallid__c;
            Id newShopsMallId = NewShopMap.get(shop.Id).Mallid__c;
            if((oldShopsMallId != newShopsMallId) && (newShopsMallId != Null)){
                Mall__c mall = new Mall__c();
                mall.Id = shop.Mallid__c;
                mall.Total_Rent_Amount__c = mallMap.get(shop.Mallid__c).Total_Rent_Amount__c + shop.Rent_Amount__c;
                recordToBeUpdated.add(mall);
            }
        }
        for(Shop__c shop : oldShopMap.Values()){
            Id oldShopsMallId = oldShopMap.get(shop.Id).Mallid__c;
            Id newShopsMallId = NewShopMap.get(shop.Id).Mallid__c;
            if((oldShopsMallId != newShopsMallId) && (oldShopsMallId != Null)){
                Mall__c mall = new Mall__c();
                mall.Id = shop.Mallid__c;
                mall.Total_Rent_Amount__c = mallMap.get(shop.Mallid__c).Total_Rent_Amount__c - shop.Rent_Amount__c;
                recordToBeUpdated.add(mall);
            }
        }

    }
    //System.debug('%%'+recordToBeUpdated);
    if(recordToBeUpdated.size()>0){
        update recordToBeUpdated;
    }
    
}