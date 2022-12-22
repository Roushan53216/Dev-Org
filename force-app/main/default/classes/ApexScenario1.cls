public class ApexScenario1 {
    
    public static void createMapOfAccountToContact(){
        Map<Id,List<Contact>> AccountIdToContactMap = new  Map<Id,List<Contact>>();
        for(Account acc : [SELECT Id
                           FROM Account ]){
                               AccountIdToContactMap.put(acc.Id,new List<Contact>());
            
        }
        for(Contact con:[SELECT Id,Name,AccountId 
                         FROM Contact
                         Where AccountId IN :AccountIdToContactMap.keySet()
                         AND AccountId != NULL ]){
                             AccountIdToContactMap.get(con.AccountId).add(con); 
            
        }
        
        for(Id AccountId : AccountIdToContactMap.keySet()){
            System.debug('Id is '+AccountId+'>>Contacts>>'+AccountIdToContactMap.get(AccountId));
        }
    }
    
    public static void createMapOfAccountToContact1(){
        Map<Id,List<Contact>> AccountIdToContactMap = new  Map<Id,List<Contact>>();
        for(Account acc : [SELECT Id,(SELECT Id,Name FROM Contacts)
                           FROM Account ]){
                               AccountIdToContactMap.put(acc.Id,acc.Contacts);
            
        }
        for(Id AccountId : AccountIdToContactMap.keySet()){
            System.debug('Id is '+AccountId+'>>Contacts>>'+AccountIdToContactMap.get(AccountId));
        }
        
    }
    
    public static void updateFieldvaluesWithmap(){
        Map<String,Account> accountIdToAccountMap = new Map<String,Account>();
        for(Contact con : [SELECT Id,Name,AccountId
                           From Contact 
                           Where Name Like 'Demo Test%']){
                               Account acc = new Account();
                               acc.Id = con.AccountId;
                               acc.Active__c = 'Yes';
                               accountIdToAccountMap.put(acc.Id,acc);
                  
                                }
        if(accountIdToAccountMap.size()>0){
            update accountIdToAccountMap.values();
        }
        
    }
    
    public static void listCheck(){
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT id,Name,AccountId
                       FROM Contact
                       WHERE Name Like 'Demo Test%'];
       List<Account> accountList = new List<Account>();
       Set<Id> accountIdSet = new Set<Id>();
        for(Contact con : contactList){
            Account acc = new Account();
            acc.Id = con.accountId;
            acc.active__c = 'Yes';
            if(!accountIdSet.contains(acc.Id)){
                accountList.add(acc);
                accountIdSet.add(acc.Id);
            }
        }
        if(accountList.size()>0){
            update accountList;
        }
    }
    
}