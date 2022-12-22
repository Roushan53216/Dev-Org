({
	fetchOppHelper : function(searchVal,component) {
		component.set("v.columnToDisplay",[
            {label:"Opportunity Name",fieldName:"Name", type:"text"},
            {label:"Close Date",fieldName:"CloseDate", type:"date"},
            {label:"Amount",fieldName:"Amount" ,type:"currency"}
        ]);
        
        var action = component.get("c.fetchOpportunity"); 
        action.setParams({
            searchKeyword:searchVal
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.listOpportunity",response.getReturnValue());
            }
            else {
                alert("An Unknown Error Occured");
            }
            
        });
        $A.enqueueAction(action);
	}
})