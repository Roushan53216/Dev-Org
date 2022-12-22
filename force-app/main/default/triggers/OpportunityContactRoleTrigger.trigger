trigger OpportunityContactRoleTrigger on OpportunityContactRole (after insert,after update,after delete) {

    Set<Id> opportunityIdSet = new Set<Id>();

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(OpportunityContactRole opp : Trigger.New){
                opportunityIdSet.add(opp.OpportunityId);
            }
            OpportunityContactRoleTriggerHelperClass.updateAmount(opportunityIdSet);
        }
        if(Trigger.isDelete){
            for(OpportunityContactRole opp : Trigger.Old){
                opportunityIdSet.add(opp.OpportunityId);
            }
            OpportunityContactRoleTriggerHelperClass.updateAmount(opportunityIdSet);
        }
        if(Trigger.isUpdate){
            for(OpportunityContactRole opp : Trigger.old){
                if(opp.OpportunityId != Null && (trigger.oldMap.get(opp.Id).OpportunityId != trigger.newMap.get(opp.Id).OpportunityId)){
                    opportunityIdSet.add(trigger.newMap.get(opp.id).OpportunityId);
                    opportunityIdSet.add(trigger.oldMap.get(opp.id).OpportunityId);
                }
                if(opp.ContactId != Null && (trigger.oldMap.get(opp.Id).ContactId != trigger.newMap.get(opp.Id).ContactId)){
                    opportunityIdSet.add(trigger.newMap.get(opp.id).OpportunityId);
                }
            }
            OpportunityContactRoleTriggerHelperClass.updateAmount(opportunityIdSet);
        }  
    }

    /*if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(OpportunityContactRole opp : Trigger.New){
                opportunityIdSet.add(opp.OpportunityId);
            }
        }
        if(Trigger.isUpdate){
            for(OpportunityContactRole opp : Trigger.old){
                if(opp.OpportunityId != Null && (trigger.oldMap.get(opp.Id).OpportunityId != trigger.newMap.get(opp.Id).OpportunityId)){
                    opportunityIdSet.add(trigger.newMap.get(opp.id).OpportunityId);
                    opportunityIdSet.add(trigger.oldMap.get(opp.id).OpportunityId);
                }
                if(opp.ContactId != Null && (trigger.oldMap.get(opp.Id).ContactId != trigger.newMap.get(opp.Id).ContactId)){
                    opportunityIdSet.add(trigger.newMap.get(opp.id).OpportunityId);
                }
            }
        }
        if(Trigger.isDelete){
            for(OpportunityContactRole opp : Trigger.old){
                opportunityIdSet.add(opp.OpportunityId);
            }
        }
    }

    OpportunityContactRoleTriggerHelperCls.totalAmount(opportunityIdSet);*/




    /*if (Trigger.isAfter) {
        if(Trigger.isInsert){
            for(OpportunityContactRole opp : Trigger.New){
                if(opp.ContactId != null && opp.OpportunityId != null){
                    conIdSet.add(opp.ContactId);
                    opportunityIdSet.add(opp.OpportunityId);
                    System.debug('###'+conIdSet);
                }
            }
        }
        if(Trigger.isUpdate){
            for(OpportunityContactRole oop : Trigger.old){
                if(oop.ContactId != null && oop.ContactId != trigger.oldMap.get(oop.Id).ContactId){
                    conIdSet.add(oop.ContactId);
                    opportunityIdSet.add(oop.Id);
                }
                if(oop.ContactId != trigger.oldMap.get(oop.Id).ContactId){
                    conIdSet.add(trigger.oldMap.get(oop.Id).ContactId);
                    opportunityIdSet.add(oop.Id);
                }
            }
        }

    }
    OpportunityContactRoleTriggerHlprCls.updateAmount(conIdSet,opportunityIdSet);*/

    

}