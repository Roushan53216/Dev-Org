public class cGoogleAppAuthenticationWithSalesforce {
    

    private string key = '313937791863-h3si93s0m85dhep49octbisaqdg2othv.apps.googleusercontent.com' ;
    private string secret = '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';
    private string redirect_uri = 'https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/apex/GoogleDriveIntegration';
    private String identificationToken ; 
    
    private String access_token; 
    private List<String> FileLst;
    public Map<String,String> FileIdAndNameMapFortheAccount{get;set;}
    //Constructor
    public cGoogleAppAuthenticationWithSalesforce()
    {
        //Once Authentication is done again constructor is called and will have to receive the value for code parameter
        identificationToken = ApexPages.currentPage().getParameters().get('code') ;
        
        FileLst=new List<String>();
        FileIdAndNameMapFortheAccount=new Map<String,String>();
        if(identificationToken != '' && identificationToken != null)
        {
            AccessToken();
        } 
    }
    
    public PageReference DriveAuth()
    {
        PageReference pg = new PageReference(new AuthURI(key , redirect_uri).AuthenticationURI) ;
        return pg;
    }
    
    public void AccessToken()
    {
        //Getting access token from google
        HttpRequest req = new HttpRequest();	
        req.setMethod('POST');
        //End point for authentication
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        //Message body for Authentication
        String messageBody = 'code='+identificationToken+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
        
        Http h = new Http();
        HttpResponse res = h.send(req);
        //Salesforce defined JSON Parser
        JSONParser parser = JSON.createParser(res.getBody());
        System.debug('%%%'+res.getBody());
        while (parser.nextToken() != null) 
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token'))
            {
                parser.nextToken();
                access_token=parser.getText();
                break;
            }
        }
        if (access_token!='' && access_token != null)
        {
            FileProperties();
        }
    }
    
   
    public  Map<String,String> FileProperties()
    {
        Map<String,String> FilePropertiesDetails=new Map<String,String>();
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        //End point URL for All the files in the drive and its ID,Name value in JSON Response
        req2.setEndpoint('https://www.googleapis.com/drive/v2/files');
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('Content-length', '0');
        req2.setHeader('Authorization' , 'Bearer'+' '+ access_token);
        req2.setTimeout(60*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        System.debug('^^^^^'+resls.getBody());
        JSONParser parserDr = JSON.createParser(resls.getBody());
        system.debug('parserDr<><>' + parserDr);
        String FileId ='';
        while (parserDr.nextToken() != null) 
        {   
            String FileName='';
           // String FileId='';
            system.debug('System.JSONToken.FIELD_NAME >>' + System.JSONToken.FIELD_NAME);
            if ((parserDr.getCurrentToken() == System.JSONToken.FIELD_NAME))
                system.debug('I am In');
            {
                //First TOKEN is Id
                if((parserDr.getText() == 'id'))
                {
                    parserDr.nextToken();               
                    FileId = parserDr.getText();
                     //FileIdAndNameMapFortheAccount.put(Fileid, Filename);
                }
                //Moving to Next Parser
                parserDr.nextToken();
                //Next Token is Name
                System.debug('##<>'+parserDr.getText());
                if((parserDr.getText() == 'title'))
                {  
                    parserDr.nextToken();
                    System.debug('File Title'+parserDr.getText());
                    Filename=parserDr.getText();
                    FileIdAndNameMapFortheAccount.put(FileId, Filename);
                  //  System.debug('##'+Filename);
                }
               // FileIdAndNameMapFortheAccount.put(Fileid, Filename);
               // system.debug('FileIdAndNameMapFortheAccount>'+FileIdAndNameMapFortheAccount);
               parserDr.nextToken();

            }
            
        }
        system.debug('FileIdAndNameMapFortheAccount>'+FileIdAndNameMapFortheAccount);
        System.debug('###'+FileIdAndNameMapFortheAccount.size());
        for(String s :FileIdAndNameMapFortheAccount.values() ){
            System.debug('%%'+s);
        }
        idList = FileIdAndNameMapFortheAccount.keySet();
        return FileIdAndNameMapFortheAccount;
    }
   
    Public Set<String> idList{get;set;} 
    
}