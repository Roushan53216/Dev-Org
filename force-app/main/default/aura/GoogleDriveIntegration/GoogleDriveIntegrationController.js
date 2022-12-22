({
    doInit : function(component, event, helper) {
        var url = window.location.href;
        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
            console.log('===results==',results);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }
        var code = getParameterByName('code');
        console.log('!#@!@#'+code);
        if(code !== undefined && code!=='' && code!==null) {
            var action = component.get('c.getAccessToken');
            action.setParams({
                'code' : code
            });
            action.setCallback(this, function(response){
                var status = response.getState();
                if(status === "SUCCESS"){
                    var accessToken = response.getReturnValue();
                    component.set("v.accessToken", accessToken);
                    console.log('!!#!'+accessToken);
                    //component.set("v.access", accessToken==true?'Authenticated..':'Not Authenticated..');
                }
                helper.getFiles(component, event, helper);
            }); 
            $A.enqueueAction(action);
            
        }
    },
    doAuth : function(component, event, helper) {
        var action  = component.get("c.createAuthURL");
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var authUrl = response.getReturnValue();
                window.location.href = response.getReturnValue();
            }            
        }); 
        var url = window.location.href;
        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(url);
            console.log('===results==',results);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }
        var code = getParameterByName('code');
        console.log('!#@!@#'+code);
        if(code !== undefined && code!=='' && code!==null) {
            var action = component.get('c.getAccessToken');
            action.setParams({
                'code' : code
            });
            action.setCallback(this, function(response){
                var status = response.getState();
                if(status === "SUCCESS"){
                    var accessToken = response.getReturnValue();
                    component.set("v.accessToken", accessToken);
                    console.log('!!#!'+accessToken);
                    //component.set("v.access", accessToken==true?'Authenticated..':'Not Authenticated..');
                }
                helper.getFiles(component, event, helper);
            }); 
            //$A.enqueueAction(action);
            
        }
        $A.enqueueAction(action);
    },
    handleFilesChange : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        console.log("##$#"+uploadedFiles);
        var attachmentId = uploadedFiles[0].documentId;
        var code = component.get("v.accessToken");
        
        var action  = component.get("c.uploadFile");
        action.setParams({
            "attachmentId": attachmentId,
            "accessToken" : code
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var responseCode = response.getReturnValue();
                if(responseCode == '200')
                    alert('File Uploaded successfully');
                else
                    alert('There was some error');
            }
        });
        
        $A.enqueueAction(action);
    },
    downloadFile : function(component, event, helper) {
        var id = event.target.getAttribute("data-id");       
        console.log('Document ID:' +id);
        var actiondownload = component.get("c.DownloadAttachment");
        
        actiondownload.setParams({
            "DownloadAttachmentID": id,
            "accesToken" : component.get("v.accessToken")
        });
        actiondownload.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var downloadUrl = response.getReturnValue();
                
                window.location.href = response.getReturnValue();
                
                console.debug('####'+downloadUrl);
            }
        });
        
        $A.enqueueAction(actiondownload);  
    },
    getFolderFiles : function(component, event, helper) {
        var id = event.target.getAttribute("data-id");       
        console.log('Document ID:' +id);
        var actiondownload = component.get("c.folderfiles");
        
        actiondownload.setParams({
            "accesToken" : component.get("v.accessToken"),
            "folderId": id
        });
        actiondownload.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var file = [];
                var fileMap = response.getReturnValue();
                for ( var key in fileMap ) {
                    file.push({value:fileMap[key], key:key});
                }
                component.set("v.FolderFiles",file);
            }
            component.set("v.showFolderFiles",true);
            component.set("v.ShowFiles",false);
        });
        
        $A.enqueueAction(actiondownload);  
    },
    hidefiles : function(component, event, helper) {
        component.set("v.ShowFiles",false);
    },
    hideBreadCrumbs : function(component, event, helper) {
        component.set("v.ShowFiles",true);
        component.set("v.showFolderFiles",false);
    }
})