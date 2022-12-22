({
    updatePickVal : function(component, recId, pField, pVal) {
        //Id recId, String kanbanField, String kanbanNewValue
        var action = component.get("c.getUpdateStage");
        action.setParams({
            "recId":recId,
            "kanbanField":pField,
            "kanbanNewValue":pVal
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                document.getElementById(recId).style.backgroundColor = "#04844b";
                setTimeout(function(){ document.getElementById(recId).style.backgroundColor = ""; }, 300);
            }
        });
        $A.enqueueAction(action);
    },
    totalmount : function(component,event,helper){
        var action = component.get("c.getTotalAmount");
        action.setParams({
            "objName":component.get("v.objName"),
            "objFields":component.get("v.objFields"),
            "kanbanField":component.get("v.kanbanPicklistField")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.dir(response.getReturnValue());
                var amunt = JSON.stringify(response.getReturnValue());
                console.log('^^'+Object.values(amunt));
                console.log('!!'+amunt);
                var result =amunt.split(',');
                console.log('$$'+result);
                
                component.set("v.totalAmount", result);
            }
        });
        console.log('$$'+"v.totalAmount");
        $A.enqueueAction(action);
    }
    
    
})