({
    executeEvent : function(component, event, helper) {
        var cmpEvt = component.getEvent("propagationEvent");
        cmpEvt.fire();
    }
})