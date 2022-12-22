public class KanbanAssignmentCls {
    
    
    
    @AuraEnabled
    public static kanbanWrapper getKanbanWrapper(String objectName,String pickList,String numberField){
        
        List<String> picklistVals = new List<String>();
        Map<String,List<sObject>> recordMap = new Map<String,List<sObject>>(); 
        List<Decimal> totalAmountList = new List<Decimal>();
        List<Integer> numOfRecordsOnDifferentPickList = new List<Integer>();
        
        String query = 'SELECT Id,Name,'+ numberField +','+pickList+' FROM ' +objectName;
        List<sObject> records = Database.query(query);
        
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(pickList).getDescribe().getPickListValues()){
            picklistVals.add(a.getValue());
            recordMap.put(a.getValue(),new List<sObject>());
        }
        for(String s : recordMap.keySet()){
            Decimal total = 0;
            Integer noOfRec = 0;
            for(sObject rec : records){
                if(s == rec.get(pickList)){
                    recordMap.get(s).add(rec);
                    Decimal num = (Decimal)rec.get(numberField);
                    total = total + num;
                    noOfRec++;
                }
            }
            totalAmountList.add(total);
            numOfRecordsOnDifferentPickList.add(noOfRec);
        }
        
        return new kanbanWrapper(picklistVals,totalAmountList,recordMap.values());
    }
    
    @AuraEnabled
    public static String getUpdateStage(Id recId, String picklistFeild, String kanbanNewValue) {
        SObject recordToBeUpdated = recId.getSObjectType().newSObject(recId); 
        recordToBeUpdated.put(picklistFeild,kanbanNewValue);
        update recordToBeUpdated;
        System.debug('#$#$'+kanbanNewValue);
        return 'Success'; 
    }
    
    //
    
    @AuraEnabled
    public static totalAmountWrapper totalAmount(String objectName,String pickList,String numberField){
        List<String> picklistVals = new List<String>();
        Map<String,List<sObject>> recordMap = new Map<String,List<sObject>>(); 
        List<Decimal> totalAmountList = new List<Decimal>();
        List<Integer> numOfRecordsOnDifferentPickList = new List<Integer>();
        
        String query = 'SELECT Id,Name,'+ numberField +','+pickList+' FROM ' +objectName;
        List<sObject> records = Database.query(query);
        
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(pickList).getDescribe().getPickListValues()){
            picklistVals.add(a.getValue());
            recordMap.put(a.getValue(),new List<sObject>());
        }
        for(String s : recordMap.keySet()){
            Decimal total = 0;
            Integer noOfRec = 0;
            for(sObject rec : records){
                if(s == rec.get(pickList)){
                    recordMap.get(s).add(rec);
                    Decimal num = (Decimal)rec.get(numberField);
                    total = total + num;
                    noOfRec++;
                }
            }
            totalAmountList.add(total);
            numOfRecordsOnDifferentPickList.add(noOfRec);
        }
        System.debug('##'+totalAmountList);
        System.debug('%%'+numOfRecordsOnDifferentPickList);
        return new totalAmountWrapper(totalAmountList,numOfRecordsOnDifferentPickList);
    }
    
    public class kanbanWrapper{
        @AuraEnabled
        Public List<String> picklistValues;
        @AuraEnabled
        Public List<Decimal> amountList;
        @AuraEnabled
        Public List<List<sObject>> recordList;
        
        public kanbanWrapper(List<String> pick,List<Decimal> amntList,List<List<sObject>> recd){
            this.picklistValues = pick ;
            this.amountList = amntList;
            this.recordList = recd ;
        }
    }
    
    public class totalAmountWrapper{
        @AuraEnabled
        Public List<Decimal> totalAmount; 
        @AuraEnabled
        Public List<Integer> numOfRecords;
        
        public totalAmountWrapper(List<Decimal> totlAmount,List<Integer> numOfRec){
            this.totalAmount = totlAmount;
            this.numOfRecords = numOfRec ;
        }
    }
    
    
    

}