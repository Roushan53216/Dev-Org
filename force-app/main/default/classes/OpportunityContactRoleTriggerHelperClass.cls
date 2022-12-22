public with sharing class OpportunityContactRoleTriggerHelperClass {

    private static Decimal totalAmount = 0 ;
    private static Set<Id> accIdSet = new Set<Id>();
    private static Set<Id> conIdSet = new Set<Id>();
    
    public static void updateAmount(Set<Id> opportunityIdSet){
        
        Map<Id,Opportunity> opportunityMapToBeUpdated = new Map<Id,Opportunity>();
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([SELECT Id,Name,
                                                                                (SELECT Id,ContactId,OpportunityId,Contact.Account.Amount__c From OpportunityContactRoles)
                                                                                FROM Opportunity 
                                                                                WHERE Id IN :opportunityIdSet]);
        //
        for(Opportunity opp : opportunityMap.values()){
            totalAmount = 0;
            accIdSet.clear();
            conIdSet.clear();
            if(opp.OpportunityContactRoles.size() == 0){
                opp.Amount = 0;
                opportunityMapToBeUpdated.put(opp.Id,opp);
            }
            else{
                for(OpportunityContactRole oppR : opp.OpportunityContactRoles){
                    System.debug('%%');
                    if(oppR.ContactId != Null &&  (conIdSet.contains(oppR.ContactId)) /*&& (accIdSet.contains(oppR.Contact.AccountId)) */){
                        opp.Amount = totalAmount;
                        opportunityMapToBeUpdated.put(opp.Id,opp);
                    }
                    else if(oppR.ContactId != Null && !(conIdSet.contains(oppR.ContactId)) && !(accIdSet.contains(oppR.Contact.AccountId))){
                        totalAmount = totalAmount + oppR.Contact.Account.Amount__c;
                        opp.Amount = totalAmount;
                        opportunityMapToBeUpdated.put(opp.Id,opp);
                        //accId = oppR.Contact.AccountId;
                        if(!(accIdSet.contains(oppR.Contact.AccountId))){
                            accIdSet.add(oppR.Contact.AccountId);
                        }
                        //conId = oppR.ContactId;
                        if(!(conIdSet.contains(oppR.ContactId))){
                            conIdSet.add(oppR.ContactId);
                        }
                    }
                }
            }
        }
        if(opportunityMapToBeUpdated.size() > 0){
            update opportunityMapToBeUpdated.values();
        }

    }

}