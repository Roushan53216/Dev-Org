public class RishabDemoClass {
    public List<Account> acc {get;set;}
    //public List<Member__c> mem {get;set;}   
      
    public RishabDemoClass()
    {
        acc = [SELECT Name, AccountNumber FROM Account LIMIT 15];
        //mem = [SELECT Name FROM Member__c];
    }
}