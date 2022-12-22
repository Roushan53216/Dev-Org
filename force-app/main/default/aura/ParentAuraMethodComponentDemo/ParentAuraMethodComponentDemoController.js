({
	getTheValue : function(component, event, helper) {
		var childComp = component.find("childCmp");
        var message = childComp.auraDemo();
	}
})