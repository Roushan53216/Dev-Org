public class DropBoxIntegration {
    private static string api_key = 'yz1dopebjhm6bi5';
    private static string secret_key = 'y8nhepd50wq87q2';
    private static string redirect_uri = 'https://d5j000007lhiyea4-dev-ed.lightning.force.com/c/DropBox.app';
    
    public class fileWrapper{
        @AuraEnabled
        public Map<String,String> fileMap = new Map<String,String>();
        @AuraEnabled
        public Map<String,String> folderMap = new Map<String,String>();
        public fileWrapper(Map<String,String> file,Map<String,String> folder){
            this.fileMap = file;
            this.folderMap = folder;
        }
    }
    public class folderFileWrapper{
        @AuraEnabled
        public Map<String,String> fileMap = new Map<String,String>();
        @AuraEnabled
        public Map<String,String> folderMap = new Map<String,String>();
        public folderFileWrapper(Map<String,String> file,Map<String,String> folder){
            this.fileMap = file;
            this.folderMap = folder;
        }
    }
    
    @AuraEnabled
    public static String createAuthURL() {
        String uri = 'https://www.dropbox.com/1/oauth2/authorize'+
            '?client_id=' + api_key +
            '&response_type=code' +
            '&redirect_uri=' + redirect_uri;
        System.debug('Uri '+uri);
        
        return uri;
    }
    
    @AuraEnabled
    public static string getAccessToken(String authorizationCode) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://api.dropboxapi.com/1/oauth2/token');  
        string bodyRequest = '';
        bodyRequest = 'code=' + EncodingUtil.urlEncode(authorizationCode, 'UTF-8');
        bodyRequest+= '&client_id=' + EncodingUtil.urlEncode(api_key, 'UTF-8');
        bodyRequest+= '&client_secret=' + EncodingUtil.urlEncode(secret_key, 'UTF-8');
        bodyRequest+= '&redirect_uri=' + EncodingUtil.urlEncode(redirect_uri, 'UTF-8');
        bodyRequest+= '&grant_type=authorization_code';
        System.debug('bodyRequest'+bodyRequest);
        req.setBody(bodyRequest);    
        req.setHeader('Content-length', string.ValueOf(bodyRequest.length()));
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setMethod('POST');
        req.setTimeout(60*1000);
        
        HttpResponse res = h.send(req);
        System.debug('Response Body '+res.getBody());
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res.getBody()) ;
        String access_Token = String.valueOf(responseMap.get('access_token'));
        System.debug('accessToken'+access_Token);

        return access_Token;
    }
    
    @AuraEnabled
    public static fileWrapper getFiles(String AccessToken){
        Map<String,String> filesMap = new Map<String,String>();
        Map<String,String> folderMap = new Map<String,String>();
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('POST');
        req2.setEndpoint('https://api.dropboxapi.com/2/files/list_folder'); 
        req2.setHeader('Authorization' , 'Bearer'+' '+ AccessToken);
        req2.setHeader('Content-Type','application/json');
        String bodyRequest = '';
            bodyRequest= '{\"include_deleted\":false,\"include_has_explicit_shared_members\":false,';
            bodyRequest+='\"include_media_info\":false,\"include_mounted_folders\":true,';
            bodyRequest+='\"include_non_downloadable_files\":true,\"path\":\"",\"recursive\":false}';
        req2.setBody(bodyRequest);
        system.debug('##'+AccessToken);
        req2.setTimeout(60*1000);
        Http h3 = new Http();
        HttpResponse response = h3.send(req2); 
        System.debug('^^^^^'+response.getBody());
        DropBoxFileWrapper fileWrapper = (DropBoxFileWrapper) JSON.deserialize(response.getBody(),DropBoxFileWrapper.class);
        for(DropBoxFileWrapper.cls_entries file : fileWrapper.entries){
            if(file.size != Null){
                filesMap.put(file.path_display,file.name);
            }
            if(file.is_downloadable == null){
                folderMap.put(file.path_display,file.name);
            }
        }
        return new fileWrapper(filesMap,folderMap);
    }
    
    @AuraEnabled
    public static folderFileWrapper getFolderFiles(String AccessToken,String folderPath){
        Map<String,String> filesMap = new Map<String,String>();
        Map<String,String> folderMap = new Map<String,String>();
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('POST');
        req2.setEndpoint('https://api.dropboxapi.com/2/files/list_folder'); 
        req2.setHeader('Authorization' , 'Bearer'+' '+ AccessToken);
        req2.setHeader('Content-Type','application/json');
        String bodyRequest = '';
            bodyRequest= '{\"include_deleted\":false,\"include_has_explicit_shared_members\":false,';
            bodyRequest+='\"include_media_info\":false,\"include_mounted_folders\":true,';
            bodyRequest+='\"include_non_downloadable_files\":true,\"path\":\"'+folderPath+'",\"recursive\":false}';
        req2.setBody(bodyRequest);
        system.debug('##'+AccessToken);
        req2.setTimeout(60*1000);
        Http h3 = new Http();
        HttpResponse response = h3.send(req2); 
        System.debug('^^^^^'+response.getBody());
        DropBoxFileWrapper fileWrapper = (DropBoxFileWrapper) JSON.deserialize(response.getBody(),DropBoxFileWrapper.class);
        for(DropBoxFileWrapper.cls_entries file : fileWrapper.entries){
            if(file.size != Null){
                filesMap.put(file.path_display,file.name);
                System.debug('##'+file.path_display);
            }
            if(file.is_downloadable == null){
                folderMap.put(file.path_display,file.name);
            }
        }
        return new folderFileWrapper(filesMap,folderMap);
    }
    @AuraEnabled
    public static String downLoadFile(String AccessToken,String folderPath){
        String downLoadLink = '';
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('POST');
        req2.setEndpoint('https://api.dropboxapi.com/2/files/get_temporary_link'); 
        req2.setHeader('Authorization' , 'Bearer'+' '+ AccessToken);
        req2.setHeader('Content-Type','application/json');
        String bodyRequest = '';
            bodyRequest= '{\"path\":\"'+folderPath+'\"}';
        System.debug('requestBody : '+bodyRequest);
        req2.setBody(bodyRequest);
        system.debug('##'+AccessToken);
        req2.setTimeout(60*1000);
        Http h3 = new Http();
        HttpResponse response = h3.send(req2); 
        System.debug('^^^^^'+response.getBody());
        DropboxDownLoadWrapper fileWrapper = (DropboxDownLoadWrapper) JSON.deserialize(response.getBody(),DropboxDownLoadWrapper.class);
        downLoadLink = fileWrapper.link;
        return downLoadLink;
        
    }
    
}