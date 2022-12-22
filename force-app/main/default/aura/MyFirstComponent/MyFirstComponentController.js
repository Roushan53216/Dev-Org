({
	doInit: function(component, event, helper) {
        var searchvalue = '';
		helper.fetchOppHelper(searchvalue,component);
	},
    searchOpportunity: function(component, event, helper){
        var searchValue = component.find("searchFeild").get("v.value");
        helper.fetchOppHelper(searchValue,component); 
    }
})