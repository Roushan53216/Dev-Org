public class UpsertDemo {
    
    public static void upsertt(){
        List<Account> accountList = [SELECT id,Name 
                                     FROM Account 
                                     WHERE Name Like 'Roushan%'];
        
        
        
        delete accountList;
    }

}