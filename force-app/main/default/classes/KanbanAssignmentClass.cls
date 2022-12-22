public with sharing class KanbanAssignmentClass {
    
    @AuraEnabled
    public static kanbanWrap getKanbanWrap(String objName, String[] objFields, String kanbanField) {
        List<String> lstPickvals=new List<String>();
        List<sObject> amountList = new List<sObject>(); 
        sObject amount ;
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(kanbanField).getDescribe().getPickListValues()){
            lstPickvals.add(a.getValue());
            //amount = Database.query('SELECT SUM(Amount) FROM '+objName+' WHERE '+kanbanField+' = '+' \'' + a.getValue() + '\'') ;
            //amountList.add(amount);
        }
        System.debug(lstPickvals);
        System.debug('@)('+amountList);
        
        String query = 'SELECT Id, ';
        for(String s:objFields){
            query += s+' ,';
        }
        query = query.removeEnd(',');
        query += ' FROM ' + objName;
        System.debug('qq  ' + query);
        
        return new kanbanWrap(Database.query(query), lstPickvals,amountList);
    }
    
    @AuraEnabled
    public static String getUpdateStage(Id recId, String kanbanField, String kanbanNewValue) {
        SObject o1 = recId.getSObjectType().newSObject(recId);
        o1.put(kanbanField,kanbanNewValue);
        update o1;
        return 'Success';
    }
    
    @AuraEnabled
    public static List<sObject> getTotalAmount(String objName, String[] objFields, String kanbanField){
        /*Map<String,List<Decimal>> newOppMap = new Map<String,List<Decimal>>();
        List<String> lstPickvals=new List<String>();
        //List<sObject> allRecords = Database.query('SELECT Id,StageName,Amount FROM Opportunity');
        //Map<Id,sObject> opp = new Map<String,Opportunity>(allRecords);
        
        list<sObject> ol = Database.query('SELECT '+kanbanField+' Amount FROM '+objName);
        List<Decimal> totalAmountList = new List<Decimal>();
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(kanbanField).getDescribe().getPickListValues()){
            lstPickvals.add(a.getValue());
            newOppMap.put(a.getValue(),new List<Decimal>());
        }
        
        //System.debug('$$'+opp);
        //System.debug('##'+opp.size());
        
        /*For(sObject op:ol){
            //System.debug('!!'+op);
            newOppMap.put(op.kanbanField,new List<Decimal>());
        }*/
        /*
        for(sObject o : ol){
            newOppMap.get().add(o.'Amount');
        }
*/
        
        //System.debug('&&'+newOppMap.values());
        //System.debug('%%'+newOppMap.size());
        /*for(String s : newOppMap.keySet()){
            System.debug('%%'+s);
            Decimal total = 0;
            List<Decimal> t = newOppMap.get(s);
            for(Integer  i=0;i<t.size();i++){
                total = total + t[i];
                System.debug(t[i]);
            }
            totalAmountList.add(total);
            t.clear();
        }
        System.debug('**'+totalAmountList);
        return totalAmountList;*/
        List<String> lstPickvals=new List<String>();
        List<sObject> amountList = new List<sObject>(); 
        sObject amount ;
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(kanbanField).getDescribe().getPickListValues()){
            lstPickvals.add(a.getValue());
            amount = Database.query('SELECT SUM(Amount) FROM '+objName+' WHERE '+kanbanField+' = '+' \'' + a.getValue() + '\'') ;
            amountList.add(amount);
        }
        System.debug(lstPickvals);
        System.debug('@)('+amountList);
        return amountList;
        
    }
    
    
    
    public class kanbanWrap{
        @AuraEnabled 
        public List<sObject> records {get;set;}
        @AuraEnabled
        public List<String> pickVals {get;set;}
        @AuraEnabled
        Public List<sObject> totalAmount{get;set;}
        
        public kanbanWrap(List<sObject> recs, List<String> pVals, List<sObject> totlAmount){
            this.records = recs;
            this.pickVals = pVals;
            this.totalAmount = totlAmount;
        }
    }
    
}