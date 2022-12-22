({
	doInit : function(component, event, helper) {
		helper.getKanbanData(component, event, helper);
        helper.totalAmount(component, event, helper);
	},
    doView: function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:navigateToSObject");
        editRecordEvent.setParams({
            "recordId": event.target.id
        });
        editRecordEvent.fire(); 
    },
    allowDrop: function(component, event, helper) {
        event.preventDefault();
    },
    
    drag: function (component, event, helper) {
        event.dataTransfer.setData("text", event.target.id);
    },
    
    drop: function (component, event, helper) {
        event.preventDefault();
        var data = event.dataTransfer.getData("text");
        console.log('#$#'+data);
        var tar = event.target;
        while(tar.tagName != 'ul' && tar.tagName != 'UL')
            tar = tar.parentElement;
        tar.appendChild(document.getElementById(data));
        var pickListFeilds = component.get("v.kanbanData.picklistValues");
        var indexNumber = tar.getAttribute('data-Pick-Val');
        var pickListField = pickListFeilds[indexNumber];
        console.log('aaaaaaaaaaaaa   :   ' + tar.getAttribute('data-Pick-Val'));
        document.getElementById(data).style.backgroundColor = "#ffb75d";
        //console.log('$$'+component.get("v.picklistField"));
        helper.updatePickVal(component,data,component.get("v.picklistField"),pickListField);
        helper.totalAmount(component, event, helper);
    }
})