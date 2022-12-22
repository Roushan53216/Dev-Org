public class testCode {
    public testCode(){
        list<Account> listAccont = new List<Account>();
        
        for(Integer i=1;i<=20;i++){
            Account acc = new Account();
            acc.Name = 'Rishab';
            listAccont.add(acc); 
        }
        
        insert listAccont;
    }
    
}