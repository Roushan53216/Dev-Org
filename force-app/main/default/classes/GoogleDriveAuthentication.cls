public class GoogleDriveAuthentication {
    
    private static string key = '313937791863-h3si93s0m85dhep49octbisaqdg2othv.apps.googleusercontent.com' ;
    private static string secret = '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';
    private static string redirect_uri = 'https://d5j000007lhiyea4-dev-ed.lightning.force.com/c/DemoApp.app';
    private String identificationToken ;     
    private static String access_token; 
    

    Public class FileWrapper{
        @AuraEnabled 
        Public Map<String,String> fileMap{get;set;}
        @AuraEnabled
        Public Map<String,String> folderMap{get;set;}
        
        public FileWrapper(Map<String,String> file,Map<String,String> folder){
            this.fileMap = file;
            this.folderMap = folder;
        }
    }

    
    @AuraEnabled
    public static String createAuthURL() {
        String key = EncodingUtil.urlEncode(key,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri='';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope=https://www.googleapis.com/auth/drive'+
            '&redirect_uri='+uri+
            '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
            '&login_hint=roushankumar9536@gmail.com&'+
            'access_type=offline';
        system.debug('##'+authuri);
        return authuri; 
    }
    @AuraEnabled
    public static String checkAccessLogin(){
        String name = (String)UserInfo.getUserId();
        System.debug('@@!'+name);
        List<Custom_Settings__c> customSettingList = [SELECT Access_Token__c 
                                                      FROM Custom_Settings__c
                                                      WHERE Name =:name];
        
        String access_token = (String)customSettingList[0].Access_Token__c;
        System.debug('%%%'+access_token);
        return access_token;
    }
    
    @AuraEnabled
    public static String getAccessToken(String code)
    {
        System.debug('%$$$'+code);
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        
        String messageBody ='code='+code+'&client_id='+key+
            '&client_secret='+secret+
            '&redirect_uri='+redirect_uri+
            '&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
        system.debug('messageBody:'+messageBody);
        
        Http callout = new Http();
        String responseText;
        HttpResponse response = callout.send(req);
        responseText = response.getBody();
        system.debug('responseText:'+responseText);
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
        String token =  String.valueOf(responseMap.get('access_token'));
        system.debug('token:'+token);
        
        
        String name = (String)UserInfo.getUserId();
        List<Custom_Settings__c> customSettingList = [SELECT id,Name,Access_Token__c,Time_in_Expire__c 
                                                      FROM Custom_Settings__c
                                                     WHERE Name =:name];
        
        Custom_Settings__c customSettings = new Custom_Settings__c();
        String accessToken = (String)responseMap.get('access_token');
        Decimal expiresIn = (Decimal)responseMap.get('expires_in');
        customSettings.Name = UserInfo.getUserId();
        customSettings.Access_Token__c = accessToken;
        customSettings.Time_in_Expire__c = System.Now().addSeconds(Integer.valueOf(expiresIn));
        if((customSettingList != Null && customSettingList.size()>0) ){
            
        }else{
            customSettingList.add(customSettings);
            insert customSettingList;
        }
        return token;
    }
    
    @AuraEnabled
    public static FileWrapper FileProperties(String accesToken)
    {
        Map<String,String> FilePropertiesDetails=new Map<String,String>();
        Map<String,String> folderMap = new Map<String,String>(); 
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        //End point URL for All the files in the drive and its ID,Name value in JSON Response
        req2.setEndpoint('https://www.googleapis.com/drive/v2/files');
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('Content-length', '0');
        req2.setHeader('Authorization' , 'Bearer'+' '+ accesToken);
        system.debug('##'+accesToken);
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
            if ((parserDr.getCurrentToken() == System.JSONToken.FIELD_NAME))
                system.debug('I am In');
            {
                //First TOKEN is Id
                if((parserDr.getText() == 'id'))
                {
                    parserDr.nextToken();               
                    FileId = parserDr.getText();
                }
                //Moving to Next Parser
                parserDr.nextToken();
                //Next Token is Name
                if((parserDr.getText() == 'title'))
                {  
                    parserDr.nextToken();
                    Filename=parserDr.getText();
                    FilePropertiesDetails.put(FileId, Filename);
                }
               parserDr.nextToken();

            }
            
        }
        system.debug('FileIdAndNameMapFortheAccount>'+FilePropertiesDetails);
        System.debug('###'+FilePropertiesDetails.size());
        
        // Making callout for folders for folders
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        //End point URL for All the files in the drive and its ID,Name value in JSON Response
        req.setEndpoint('https://www.googleapis.com/drive/v3/files');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        req.setHeader('Content-length', '0');
        req.setHeader('Authorization' , 'Bearer'+' '+ accesToken);
        system.debug('##'+accesToken);
        req.setTimeout(60*1000);
        Http http = new Http();
        HttpResponse response = http.send(req);
        System.debug('^^^^^'+response.getBody());
        //Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(response.getBody()) ;
        //System.debug('!!!!!'+responseMap);
        //System.debug('Size'+responseMap.size());
        JSONFileWrapper fileWrapper = (JSONFileWrapper)JSON.deserialize(response.getBody(), JSONFileWrapper.class);
        System.debug('JSON Object'+fileWrapper.files);
        for(JSONFileWrapper.cls_files file : fileWrapper.files){
            System.debug('FIles : '+file.mimeType);
            String mimeTyp = file.mimeType;
            if(mimeTyp.contains('folder')){
                folderMap.put(file.id,file.name);
            }
        }
        System.debug('folderMap'+folderMap);
        return new FileWrapper(FilePropertiesDetails,folderMap); 
    }
    
    @AuraEnabled
    public static String uploadFile(String attachmentId, String accessToken) {
        List<ContentVersion> cvFile = [SELECT VersionData,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: attachmentId];
        Blob myBlob = cvFile[0].VersionData;
       String url = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=media';
       string authorizationHeader = 'Bearer ' + accessToken; 
       Integer contentSize = myBlob.size();
       HttpRequest req = new HttpRequest();
       req.setheader('Authorization',authorizationHeader);
       req.setheader('Content-Length',String.valueOf(contentSize));
       req.setheader('Content-Type','image/'+cvFile[0].FileType);
       req.setMethod('POST');
       req.setEndpoint(url);
       req.setBodyAsBlob(myBlob);
       Http h = new Http(); 
      
       Httpresponse resp = h.send(req);
        System.debug('###'+attachmentId);
        System.debug('###'+myBlob);
        System.debug('###'+contentSize);
       return String.valueOf(resp.getStatuscode());
        
        
    }
    @AuraEnabled
    public static String DownloadAttachment(String DownloadAttachmentID,String accesToken){
        System.debug('###'+DownloadAttachmentID);
        String downloadUrl='';
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        //End point URL for All the files in the drive and its ID,Name value in JSON Response
        req2.setEndpoint('https://www.googleapis.com/drive/v2/files/'+DownloadAttachmentID);
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('Content-length', '0');
        req2.setHeader('Authorization' , 'Bearer'+' '+ accesToken);
        system.debug('##'+accesToken);
        req2.setTimeout(60*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        System.debug('^^^^^'+resls.getBody());
        JSONParser parserDr = JSON.createParser(resls.getBody());
        while (parserDr.nextToken() != null) 
        {   
            if ((parserDr.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parserDr.getText() == 'webContentLink'))
            {
                //First TOKEN
                parserDr.nextToken();
                downloadUrl = parserDr.getText();
                
            }
        }
        System.debug('downloadUrl '+downloadUrl);
        return downloadUrl;
    }
    
    @AuraEnabled 
    public static Map<String,String> folderfiles(String accesToken,String folderId){
        Map<String,String> fileMap = new Map<String,String>();
        System.debug('===>>'+accesToken);
        System.debug('>>>>>'+folderId);  
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        req2.setEndpoint('https://www.googleapis.com/drive/v2/files/'+folderId+'/children');
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('Content-length', '0');
        req2.setHeader('Authorization' , 'Bearer'+' '+ accesToken);
        system.debug('##'+accesToken);
        req2.setTimeout(60*1000);
        Http h3 = new Http();
        HttpResponse response = h3.send(req2);
        JSONFolderWrapper fileWrapper = (JSONFolderWrapper)JSON.deserialize(response.getBody(), JSONFolderWrapper.class);
        System.debug('FolderFIles'+fileWrapper.items);
        for(JSONFolderWrapper.cls_items file : fileWrapper.items){
                fileMap.put(file.id,file.kind);
        }
        return fileMap;
    }
}