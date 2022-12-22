public with sharing class OpportunityContactRoleTriggerHelperCls {
    private  static Decimal totalAmount = 0;
    private static Id accId ;
    static List<Id> accIdList = new List<Id>();
    static List<Id> oppContRoleId = new List<Id>();
    private static Id oppContId;
    private static Id OpportunityIds;
    static List<Id> opportunityIdList = new List<Id>();
    
    public static void totalAmount(Set<Id> opportunityIdSet){

        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
        List<Opportunity> opportunityList = [SELECT Id,Name,Amount,(SELECT Id,ContactId FROM OpportunityContactRoles) 
                                             FROM Opportunity 
                                             WHERE Id IN :opportunityIdSet];
        
        //ww
        System.debug('----->>'+opportunityList);
        Set<Id> contactIdSet = new Set<Id>();
        for(Opportunity opp : opportunityList){
            opportunityIdList.add(opp.Id);
            for(OpportunityContactRole oopr : opp.OpportunityContactRoles){
                contactIdSet.add(oopr.ContactId);
            }
        }
        System.debug('=====>>>'+contactIdSet);
        Map<Id,Contact> contactMap = new Map<Id,Contact>([SELECT Id,Name,Account.Amount__c,(SELECT Id,ContactId,OpportunityId FROM OpportunityContactRoles)
                                                          FROM Contact
                                                          WHERE Id IN : contactIdSet]);

        //tt
        System.debug('==>>>'+contactMap.values());

        for(Opportunity op : opportunityList){
            System.debug('@@'+op.Id);
            accIdList.clear();
            oppContRoleId.clear();
            totalAmount = 0 ;
            for(Contact con : contactMap.values()){
                System.debug('X>X>X==>'+con.AccountId);
                if(con.AccountId != Null && (accIdList.contains(con.AccountId))){
                    for(OpportunityContactRole oop : con.OpportunityContactRoles){
                        if(oop.ContactId != Null && !(oppContRoleId.contains(oop.ContactId))){
                            //Opportunity  oppor = new Opportunity();
                            //oppor.Id = oop.OpportunityId;
                            op.Amount = totalAmount; 
                            opportunityMap.put(op.Id,op);
                            System.debug('Contain');
                            oppContId = oop.ContactId;
                            if(!(oppContRoleId.contains(oppContId))){
                                oppContRoleId.add(oppContId);
                            }
                        }
                    }
                }
                else if(con.AccountId != Null){
                    for(OpportunityContactRole oop : con.OpportunityContactRoles){
                        if(oop.ContactId != Null && !(oppContRoleId.contains(oop.ContactId))){
                            //Opportunity  oppor = new Opportunity();
                            //oppor.Id = oop.OpportunityId;
                            totalAmount = totalAmount + contactMap.get(con.Id).Account.Amount__c;
                            System.debug('##'+totalAmount);
                            System.debug('&&&'+con.Account.Amount__c);
                            op.Amount = totalAmount;
                            opportunityMap.put(op.Id,op);
                            oppContId = oop.ContactId;
                            if(!(oppContRoleId.contains(oppContId))){
                                oppContRoleId.add(oppContId);    
                            }
                            System.debug('$$$===>'+totalAmount);
                            System.debug('NOt Contain');
                            //oppListToBeUpdated.add(oppor);
                        }
                    }
                }
                accId = con.AccountId;
                if(!(accIdList.contains(accId))){
                    accIdList.add(accId);
                }
                System.debug('%%&&%%'+accIdList);
            }
        }

        if(opportunityMap.size()>0){
            update opportunityMap.values();
            System.debug('>>'+opportunityMap);
        }
    }

}