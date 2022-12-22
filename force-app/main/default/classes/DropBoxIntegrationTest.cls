@isTest
public class DropBoxIntegrationTest {
    
    @isTest
    static void unitTest1(){
        DropBoxIntegration DBI = new DropBoxIntegration();
        //Test.setMock(HttpCalloutMock.class, new DropBoxHttpMock());
        String res = DropBoxIntegration.getAccessToken('sde');
        //System.assertEquals(200,res.getStatusCode()); 
        
    }
    
    
}