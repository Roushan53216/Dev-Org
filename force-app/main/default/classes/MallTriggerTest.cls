@isTest
public class MallTriggerTest {
    public static testMethod void test(){
        Mall__c mall = new Mall__c(Name='TestClassMall',Active_Mall__c =true);
        insert mall;
        
        Shop__c shop = new Shop__c(Name='TestClassShop',Mallid__c = mall.Id);
        insert shop;
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(mall.Id);
        Test.startTest();
        MallTriggerHelperClass.updateCheckBox(idSet);
        Test.stopTest();
        Shop__c sho = [SELECT Active_Shop__c FROM Shop__c WHERE id= :shop.Id LIMIT 1];
        System.assertEquals(false, sho.Active_Shop__c);
        
    }
}