@isTest
public class UpadteContactOfAccountBAtchTest {
    private static void test(){
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        for(Integer i=0;i<5;i++){
            Account acc = new Account(Name='Test'+i,phone='7320920378');
            accList.add(acc);
        }
        
    }

}