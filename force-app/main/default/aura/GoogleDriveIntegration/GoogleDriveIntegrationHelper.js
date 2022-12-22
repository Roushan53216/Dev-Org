({
    getFiles : function(component, event, helper) {
        var action = component.get("c.FileProperties");
        component.set("v.spinner",true);
        action.setParams({
            "accesToken" : component.get("v.accessToken")
        });
        console.log('access '+component.get("v.accessToken"));
        action.setCallback(this, function(response){
            var status = response.getState();
            if (status === "SUCCESS") {
                var file = [];
                var Wrapperfile = response.getReturnValue();
                var fileMap = Wrapperfile.fileMap;
                for ( var key in fileMap ) {
                    file.push({value:fileMap[key], key:key});
                }
                component.set("v.files", file);
                var folders = [];
                var folderMap = Wrapperfile.folderMap;
                for(var key in folderMap){
                    folders.push({value:folderMap[key], key:key});
                }
                component.set("v.folders",folders);
                component.set("v.ShowFiles", true);
            }
            console.log("===>>"+file);
            component.set("v.spinner",false);
            //console.log(component.get("v.pageReference").state.testAttribute);
        });
        
        $A.enqueueAction(action);
    }
    
})