({
	fireChild : function(component, event, helper) {
        var appEvent = $A.get("e.c:AppEventTest");
        appEvent.setParams({
            "message" : "Hey This is Child"
        });
        appEvent.fire();
	}
})