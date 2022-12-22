@isTest
public class TestClassCallout {
	@isTest
    static void testAnimals(){
        Test.setMock(HttpCalloutMock.class, new CalloutDemoTest());
        
        HttpResponse res = CalloutDemo.callOut();
        String expected = '{"Animals":["Horse","Dog","Tiger","Lion","Cat","Mouse"]}' ;
        
        System.assertEquals(200,res.getStatusCode()); 
        System.assertEquals(res.getBody(), expected);
    }
}