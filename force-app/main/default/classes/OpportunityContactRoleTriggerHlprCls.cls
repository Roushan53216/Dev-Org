public class OpportunityContactRoleTriggerHlprCls {
    private  static Decimal totalAmount = 0;
    private static Id accId ;
    static List<Id> accIdList = new List<Id>();

    public static void updateAmount(Set<Id> conIdSet,Set<Id> opportunityIdSet){
        System.debug('>>>'+conIdSet); 

        Map<Id,Contact> OppConMap = new  Map<Id,Contact>([SELECT Id,Account.Amount__c,AccountId,
                                                        (SELECT Id,ContactId,OpportunityId FROM OpportunityContactRoles ) 
                                                        From Contact 
                                                        WHERE Id IN :conIdSet]);
        List<Opportunity> opportunityList = [SELECT Id,Amount,(SELECT Id,Role FROM OpportunityContactRoles) FROM Opportunity WHERE Id IN :opportunityIdSet];
        System.debug('###'+OppConMap);
        /*for(Opportunity oop:opportunityList){
            totalAmount = oop.Amount;
        }*/
        if(opportunityList[0].Amount != Null){
            totalAmount = opportunityList[0].Amount;
        }
        System.debug('!!$$%%'+totalAmount);
        //System.debug('====>>>'+OppConMap);
        
        //List<Contact> accountIdList =[SELECT AccountId FROM Contact WHERE Id IN :conIdSet];
        //System.debug('())()'+accountIdList);
        //Set<Id> accIdSet = (new Map<Id,SObject>(accountIdList)).keySet();
        //System.debug('++++>>>'+accIdSet);
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
        //List<Opportunity> oppListToBeUpdated = new  List<Opportunity>();
        
        for(Contact con : OppConMap.values()){
            //Opportunity  oppor = new Opportunity();
            System.debug('X>X>X==>'+con.AccountId);
            if(con.AccountId != Null && (accIdList.contains(con.AccountId))){
                for(OpportunityContactRole oop : con.OpportunityContactRoles){
                    if(oop.ContactId != Null ){
                        Opportunity  oppor = new Opportunity();
                        oppor.Id = oop.OpportunityId;
                        oppor.Amount = totalAmount + OppConMap.get(con.Id).Account.Amount__c; 
                        opportunityMap.put(oppor.Id,oppor);
                        System.debug('Contain');
                    }
                }
            }
            else if(con.AccountId != Null){
                for(OpportunityContactRole oop : con.OpportunityContactRoles){
                    if(oop.ContactId != Null ){
                        Opportunity  oppor = new Opportunity();
                        oppor.Id = oop.OpportunityId;
                        totalAmount = totalAmount + OppConMap.get(con.Id).Account.Amount__c;
                        System.debug('##'+totalAmount);
                        System.debug('&&&'+con.Account.Amount__c);
                        oppor.Amount = totalAmount;
                        opportunityMap.put(oppor.Id,oppor);
                        System.debug('$$$===>'+totalAmount);
                        System.debug('NOt Contain');
                        //oppListToBeUpdated.add(oppor);
                    }
                }
                //oppor.Amount = totalAmount;
                //oppListToBeUpdated.add(oppor);
            }
            accId = con.AccountId;
            if(!(accIdList.contains(accId))){
                accIdList.add(accId);
            }
            System.debug('%%&&%%'+accIdList);
        }

        if(opportunityMap.size()>0){
            update opportunityMap.values();
        }

    }   
}