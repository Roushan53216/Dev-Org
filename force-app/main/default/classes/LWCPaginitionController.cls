public with sharing class LWCPaginitionController {


    public class RecordsAndSizeWrapper{
        @AuraEnabled
        public List<sObject> records;
        @AuraEnabled 
        public Integer totalRecords;
        @AuraEnabled
        public boolean isPrevious = false;
        @AuraEnabled
        public boolean isLast = false;
    }

    public class fieldsAndNameWrapper{
        @AuraEnabled
        public List<String> allFeilds;
        @AuraEnabled
        public String nameFeild;
        @AuraEnabled
        public List<string> qureyableField;
    }

    public class TypeOfFeilds{
        @AuraEnabled
        public List<String> textFields;
        @AuraEnabled
        public list<String> booleanFields;
        @AuraEnabled
        public Map<String,List<String>> allPicklistFieldsValues;
        @AuraEnabled
        public list<String> stringFields;
        @AuraEnabled
        public list<String> numberFields;
        @AuraEnabled
        public list<String> phoneFields;
        @AuraEnabled
        public list<String> dateFields;
        @AuraEnabled
        public list<String> dateTimeFields;

    }

    public class JsonParameters{//List<String> selectedFields,String selectedObject,Integer noOfRecord,String fristRecId,String lastRecId,string nameFeild,string lastRecName,String firstRecName,string sortByFeild,string sortDirection
        public List<String> selectedFields;
        public String selectedObject;
        public Integer noOfRecord;
        public String fristRecId;
        public String lastRecId;
        public string nameFeild;

    }

    @AuraEnabled
    public static List<string> getAllObjects(){
        List<String> results = new List<String>();
        try {
            for(SObjectType sType: Schema.getGlobalDescribe().values()) {
                DescribeSObjectResult res = sType.getDescribe();
                if(res.isQueryable()){
                    results.add(res.getName());
                }
            }
        results.sort(); 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return results;
    }

    @AuraEnabled
    public static fieldsAndNameWrapper getAllFeildsOfSelectedObj(String selectedObject){
        List<String> results = new List<String>();
        List<String> qureyFeild = new List<String>();
        fieldsAndNameWrapper wrap = new fieldsAndNameWrapper();
        try {
            if(selectedObject != null) {
                for(SObjectField sField: Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().values()) {
                    DescribeFieldResult res = sField.getDescribe();
                    if(res.isNameField()){
                        wrap.nameFeild = res.getName();
                        //nameFeild = res.getName();
                    }else{
                        results.add(res.getName());
                    }
                    if(res.isFilterable()){
                        qureyFeild.add(res.getName());
                    }
                }
                wrap.allFeilds = results;
                wrap.qureyableField = qureyFeild;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return wrap;
    }

    @AuraEnabled
    public static TypeOfFeilds checkFieldTypeForFilter(String selectedObj,List<String> selectedFeilds){
        TypeOfFeilds fieldTyp = new TypeOfFeilds();
        list<String> booleanFlds = new List<String>();
        list<String> stringFields = new List<String>();
        list<String> numberFields = new List<String>();
        list<String> phoneFields = new List<String>();
        list<String> dateFields = new List<String>();
        list<String> dateTimeFields = new List<String>();
        Map<String,List<String>> pickVals = new Map<String,List<String>>();
        try {
            for(String fieldStr : selectedFeilds){
                Schema.DisplayType describedField = Schema.getGlobalDescribe().get(SelectedObj).getDescribe().fields.getMap().get(fieldStr).getDescribe().getType();
                System.debug('=====>>>> '+describedField);
                if(String.valueOf(describedField).equalsIgnoreCase('PICKLIST')){
                    pickVals.put(fieldStr,getPicklistValue(selectedObj,fieldStr));
                }else if(String.valueOf(describedField).equalsIgnoreCase('BOOLEAN')){
                    booleanFlds.add(String.valueOf(fieldStr));
                }else if(String.valueOf(describedField).equalsIgnoreCase('STRING')){
                    stringFields.add(String.valueOf(fieldStr));
                }else if(String.valueOf(describedField).equalsIgnoreCase('DOUBLE') || String.valueOf(describedField).equalsIgnoreCase('CURRENCY') 
                                    || String.valueOf(describedField).equalsIgnoreCase('INTEGER') 
                                    || String.valueOf(describedField).equalsIgnoreCase('DOUBLE')){
                    numberFields.add(String.valueOf(fieldStr));
                }else if(String.valueOf(describedField).equalsIgnoreCase('PHONE')){
                    phoneFields.add(String.valueOf(fieldStr));
                }else if(String.valueOf(describedField).equalsIgnoreCase('DATE')){
                    dateFields.add(String.valueOf(fieldStr));
                }else if(String.valueOf(describedField).equalsIgnoreCase('DATE')){
                    dateFields.add(String.valueOf(fieldStr));
                }else if(String.valueOf(describedField).equalsIgnoreCase('DATETIME')){
                    dateTimeFields.add(String.valueOf(fieldStr));
                }
            }
            fieldTyp.allPicklistFieldsValues = pickVals;
            fieldTyp.booleanFields = booleanFlds;
            fieldTyp.stringFields = stringFields;
            fieldTyp.numberFields = numberFields;
            fieldTyp.phoneFields = phoneFields;
            fieldTyp.dateFields = dateFields;
            fieldTyp.dateTimeFields = dateTimeFields;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return fieldTyp;
    }

    private static List<String> getPicklistValue(String SelectedObj,String fieldName){
        List<String> pickListValuesList= new List<String>();
		for( Schema.PicklistEntry pickListVal : Schema.getGlobalDescribe().get(SelectedObj).getDescribe().fields.getMap().get(fieldName).getDescribe().getPickListValues()){
			pickListValuesList.add(pickListVal.getValue());
            System.debug('$$$$===> '+pickListVal);
		}     
		return pickListValuesList;
    }


    @AuraEnabled
    public static RecordsAndSizeWrapper getAllRecords(List<String> selectedFields,String selectedObject,Integer noOfRecord,String fristRecId,String lastRecId,string nameFeild,string lastRecName,String firstRecName,string sortByFeild,string sortDirection){
        //LWCPaginitionControllerWrapper jsn = (LWCPaginitionControllerWrapper)System.JSON.deserialize(JsonWrap,LWCPaginitionControllerWrapper.class);
        //System.debug(JsonWrap);
        List<sObject> allRecords = new List<sObject>(); 
        RecordsAndSizeWrapper wrap = new RecordsAndSizeWrapper();
        try {

            String query =  '';
            String finalQueryString = '';
            String perPageRecord = String.valueOf(noOfRecord);
            //String offSetSize = String.valueOf(offSet);
            for(Integer i=0;i<selectedFields.size();i++){
                if(i == (selectedFields.size()-1)){    
                    query = query + selectedFields[i] ;
                }
                else{
                    query = query + selectedFields[i] + ',';
                }
            }
            //finalQueryString = 'SELECT Id,'+nameFeild+','+query+' FROM '+selectedObject+' LIMIT '+perPageRecord+' OFFSET '+offSetSize;
            System.debug('hello');
            if(String.isEmpty(fristRecId) && String.isEmpty(lastRecId) ){
                finalQueryString = 'SELECT Id,'+nameFeild+','+query+' FROM '+selectedObject+' ORDER By '+sortByFeild+' '+sortDirection+',Id'+' LIMIT '+perPageRecord;//ASC
                System.debug('qq===>>  '+finalQueryString);

            }
            //finalQueryString = 'SELECT Id,'+nameFeild+','+query+' FROM '+selectedObject+' WHERE '+nameFeild+'> \''+lastRecName+'\''+' OR ('+nameFeild+'> \''+lastRecName+'\''+ 'AND' +'Id>\''+ lastRecId +'\''+')'+' ORDER By '+nameFeild+',Id ASC'+' LIMIT '+perPageRecord  ;
            else{
                // For Previous Button Click
                if(!String.isEmpty(fristRecId) && String.isEmpty(lastRecId) ){
                    if(String.isEmpty(sortDirection) ){
                        sortDirection = 'DESC';
                    }
                    finalQueryString = 'SELECT Id,'+nameFeild+','+query+' FROM '+selectedObject+' WHERE '+sortByFeild+'< \''+firstRecName+'\''+' OR ('+sortByFeild+'<= \''+firstRecName+'\''+ ' AND ' +'Id<\''+ fristRecId +'\''+')'+' ORDER By '+sortByFeild+' '+sortDirection+',Id '+' LIMIT '+perPageRecord  ;
                    //finalQueryString = 'SELECT Id,'+nameFeild+','+query+' FROM '+selectedObject+' WHERE Id<\''+ fristRecId +'\''+' ORDER By '+nameFeild+',Id DESC'+' LIMIT '+perPageRecord;//DESC
                    wrap.isPrevious = true;
                    wrap.isLast = false;
                    System.debug('qq===>>Else  '+finalQueryString);
                }
                // For Number of Records Per Page Button Click
                /*
                else if(!String.isEmpty(fristRecId) && !String.isEmpty(lastRecId) && fristRecId != 'last'){
                    if(String.isEmpty(sortDirection) ){
                        sortDirection = 'ASC';
                    }
                    finalQueryString = 'SELECT Id,'+nameFeild+','+query+' FROM '+selectedObject+' WHERE Id>=\''+ fristRecId +'\''+' ORDER By '+sortByFeild+' '+sortDirection+',Id '+' LIMIT '+perPageRecord;//ASC
                    System.debug('qq===>>Elserrrec  '+finalQueryString);
                }*/
                // For NEXT Button Click
                else if(String.isEmpty(fristRecId) && !String.isEmpty(lastRecId)){
                    if(String.isEmpty(sortDirection) ){
                        sortDirection = 'ASC';
                    }
                    finalQueryString = 'SELECT Id,'+nameFeild+','+query+' FROM '+selectedObject+' WHERE '+sortByFeild+'> \''+lastRecName+'\''+' OR ('+sortByFeild+'>= \''+lastRecName+'\''+ ' AND ' +'Id>\''+ lastRecId +'\''+')'+' ORDER By '+sortByFeild+' '+sortDirection+',Id '+' LIMIT '+perPageRecord  ;//ASC
                    System.debug('qq===>>Elserrnex  '+finalQueryString);
                }
                // for Last Page Button Click
                else if(fristRecId == 'last' && lastRecId == 'last'){
                    if(String.isEmpty(sortDirection) ){
                        sortDirection = 'DESC';
                    }
                    finalQueryString = 'SELECT Id,'+nameFeild+','+query+' FROM '+selectedObject+' ORDER By '+sortByFeild+' '+sortDirection+',Id '+' LIMIT '+perPageRecord; //DESC
                    wrap.isLast = true;
                    wrap.isPrevious = false;
                    System.debug('qq===>>Elserrlas  '+finalQueryString);
                }
            }

            allRecords = Database.query(finalQueryString);
            wrap.records = allRecords;
            
            Integer totalRec = Database.countQuery('SELECT COUNT() FROM '+selectedObject);
            wrap.totalRecords = totalRec;
            System.debug('rec : '+allRecords);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return wrap;
    }

    /*@AuraEnabled(cacheable=true)
    public static List<Account> demoAcc(){
        List<Account> accList = new List<Account>();
        try {

            accList = [SELECT id,Name,Industry,Description from Account Limit 10];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return accList;
    }*/
    


}