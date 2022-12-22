global class UpadteContactOfAccountBAtch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id,Name,phone,(SELECT Id,Name,phone FROM Contacts) FROM Account]);
    }
    
    global void execute(Database.BatchableContext bc,List<Account> accList){
        list<Contact> conList = new List<Contact>();
        for(Account acc : accList){
            if(acc.Contacts.Size()>0){
                for(Contact con : acc.contacts){
                con.phone  = acc.phone;
                conList.add(con);
            }
            }
        }
        update conList;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('>>>>H');
    }

}