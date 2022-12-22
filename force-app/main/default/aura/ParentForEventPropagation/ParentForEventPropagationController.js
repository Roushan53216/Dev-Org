({
	catchEvent : function(component, event, helper) {
		var message = event.getParam("message");
        var number = event.getParam("number");
        
        component.set("v.message",message);
        component.set("v.number",number); 
	}
})