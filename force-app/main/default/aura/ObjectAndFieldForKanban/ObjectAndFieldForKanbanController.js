({
    init : function(component, event, helper) {
        helper.getData(component, event, helper);
    },
    handleChange : function(component, event, helper){
        helper.getAllFields(component, event, helper);
        helper.getAllPickListFeild(component, event, helper);
    },
    passObjAndFeild : function(component, event, helper){
        var kanbanEvent = component.getEvent("knbanEvent");
        var obj = component.get("v.selectedObject");
        console.log('$$'+obj);
        var fld = component.get("v.selectedField"); 
        console.log('$$'+fld);
        var pckVal = component.get("v.selectedPickVal");
        console.log('$$'+pckVal);
        kanbanEvent.setParams({
            "objectName" : obj,
            "feildsName" : fld,
            "pickListVal" : pckVal
        });
        kanbanEvent.fire();
    }
 })