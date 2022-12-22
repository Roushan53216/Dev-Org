({
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
                'authorizationCode' : code
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
    folderFiles : function(component, event, helper) {
        var path = event.target.getAttribute("data-id");       
        console.log('Path :' +path);
        component.set("v.breadcrumbPath");
        helper.breadCrumbs(component, event, path);
        var actiondownload = component.get("c.getFolderFiles");
        component.set("v.spinner",true);
        
        actiondownload.setParams({
            "AccessToken" : component.get("v.accessToken"),
            "folderPath": path
        });
        actiondownload.setCallback(this, function(response){
            var status = response.getState();
            if (status === "SUCCESS") {
                var file = [];
                var Wrapperfile = response.getReturnValue();
                var fileMap = Wrapperfile.fileMap;
                for ( var key in fileMap ) {
                    file.push({value:fileMap[key], key:key});
                }
                component.set("v.filesOfFolders", file);
                var folders = [];
                var folderMap = Wrapperfile.folderMap;
                for(var key in folderMap){
                    folders.push({value:folderMap[key], key:key});
                }
                component.set("v.foldersOfFolders",folders);
            }
            console.log("===>>"+file);
            component.set("v.spinner",false);
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
    },
    downloadFile : function(component, event, helper) {
        var path = event.target.getAttribute("data-id");       
        console.log('Path :' +path);
        var action = component.get("c.downLoadFile");
        
        action.setParams({
            "AccessToken": component.get("v.accessToken"),
            "folderPath" : path
        });
        action.setCallback(this, function(response){
            var status = response.getState();
            if(status === "SUCCESS"){
                var downloadUrl = response.getReturnValue();
                
                window.location.href = response.getReturnValue();
                
                console.debug('####'+downloadUrl);
            }
        });
        
        $A.enqueueAction(action);   
    }
})