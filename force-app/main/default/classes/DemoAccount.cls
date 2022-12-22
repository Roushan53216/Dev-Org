public class DemoAccount {
    public static void insertAccount(){
        List<Account> accountList = new List<Account>();
        for(Integer i=1;i<=200;i++){
            Account acc = new Account();
            acc.Name = 'Roushan Kumar' ;
        	acc.Active__c = 'Yes' ;
            acc.industry = 'Technology';
            accountList.add(acc);
        }
        if(accountList.size()>0){
            insert accountList;
        }
        for(Account acc : accountList){
            System.debug('Account Name is '+acc.Name+' and id is '+acc.id);
        }
    }
    public static void updaterecord(){
        List<Account> accountList = new List<Account>();
        accountList = [SELECT id,Name,Active__c From Account];
        for(Account acc : accountList){
            System.debug(acc);
        }
        }
}