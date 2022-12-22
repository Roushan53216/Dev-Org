({
	getKanbanData : function(component, event, helper) {
		var action = component.get("c.getKanbanWrapper");
        action.setParams({
            "objectName": component.get("v.objectName"),
            "pickList" : component.get("v.picklistField"),
            "numberField" : component.get("v.NumberField")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.dir(response.getReturnValue());
                component.set("v.kanbanData", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    updatePickVal : function(component, recId, pField, pVal) {
        //Id recId, String kanbanField, String kanbanNewValue
        var action = component.get("c.getUpdateStage");
        action.setParams({
            "recId":recId,
            "picklistFeild":pField,
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
    totalAmount : function(component, event, helper){
        var action = component.get("c.totalAmount");
        action.setParams({
            "objectName": component.get("v.objectName"),
            "pickList" : component.get("v.picklistField"),
            "numberField" : component.get("v.NumberField")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.dir(response.getReturnValue());
                component.set("v.totalAmountandRec", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})