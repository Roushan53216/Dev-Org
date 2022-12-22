public class MyFirstComponentController {
    @AuraEnabled
    public static List<Opportunity> fetchOpportunity(String searchKeyword){
        List<Opportunity> returnList = new List<Opportunity>();
        
        String searchKy = String.isBlank(searchKeyword) ? '%%' : searchKeyword + '%';
        returnList = [SELECT Name,CloseDate,Amount FROM Opportunity Where Name Like :searchKy Limit 10];
        System.debug('<><>'+searchKy);
        System.debug('>>>>'+returnList);
        
        return returnList;
    }

}