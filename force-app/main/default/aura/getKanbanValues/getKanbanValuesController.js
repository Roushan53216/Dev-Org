({
	getFieldsAndObj : function(component, event, helper) {
		var objName = event.getParam("objectName");
        console.log('$$'+objName);
        var fieldName = event.getParam("feildsName");
        var PickListVal = event.getParam("pickListVal");
        
        component.set("v.objs",objName);
        component.set("v.feilds",fieldName);
        component.set("v.PickVals",PickListVal); 
	}
})