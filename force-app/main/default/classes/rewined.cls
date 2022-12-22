public class rewined {
    public static void checkClass(){
        List<Account> accList = [SELECT Id,Name From Account Limit 10];
        //System.debug('=====>>>>>  '+accList);
        //System.debug('=====>>>>>  '+accList.size());
        Set<String> accSet = new Set<String>();
        /*for(Account acc : accList){
            accSet.add(acc.Id);
        }*/
        
        System.debug('====>>>>  '+accSet);
        
        
        
        
    }

}