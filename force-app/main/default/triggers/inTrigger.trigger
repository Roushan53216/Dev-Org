trigger inTrigger on Lead (before insert) {
    
    List<String> leadNames = new List<String>();
    for(Lead leads : Trigger.new){
        if(String.isBlank(leads.FirstName) && leads.LastName.containsWhitespace()){
            leadNames = leads.LastName.split(' ');
            leads.FirstName = leadNames[0];
            leads.LastName = leadNames[1];
        }
    }

}