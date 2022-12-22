({
	fireChild : function(component, event, helper) {
		var evnt = component.getEvent("propagationDemo");
        var m = component.get("v.messageString");
        var n = component.get("v.numbr");
        evnt.setParams({
            "message" : m ,
            "number" : n
        });
        evnt.fire();
	}
})