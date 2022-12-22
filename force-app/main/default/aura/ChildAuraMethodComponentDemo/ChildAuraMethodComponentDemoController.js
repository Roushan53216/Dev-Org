({
	callAuraMethod : function(component, event, helper) {
		var message = event.getParam('arguments');
        if(message){
            var param1 = message.para1;
            var param2 = message.para2;
            alert(param1+' '+param2);
        }
	}
})