public class FirstCustomController {
    
    public list<SelectOption> selectedobject { get; set; }

    public String objectName { get; set; }    
    public set<string> flds{get;set;}
    
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public FirstCustomController(){
                   
                selectedobject = new list<SelectOption>();  
                  selectedobject.add(new selectoption('','-None-'));
                  list<schema.SobjectType> lst=schemaMap.values();
                  for(schema.SobjectType ss:lst){
                      selectedobject.add(new selectoption(ss.getDescribe().getLocalName(),ss.getDescribe().getLabel()));
                      selectedobject.sort();
               }
                 flds= new set<string>();
                  lsps=new list<SelectOption>();
    }
 
      
      public String fields { get; set; }
      
       public list<SelectOption> lsps{get;set;}
      
       public void function() {
       
         if(objectName!=null || objectName!=''){
           Map<string,Schema.SObjectField> mpConField=schemaMap.get(objectName).getDescribe().fields.getMap();
               flds=mpConField.keySet();
                                
                   for(string name:flds){
                   Schema.DescribeFieldResult fldResult=mpConField.get(name).getDescribe();
                    lsps.add(new SelectOption(fldResult.getName(),fldResult.getName()));
                    lsps.sort();                    
                   }
                }        
    }

}