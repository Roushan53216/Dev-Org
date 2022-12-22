trigger TestTrigger on Lead (after insert) {
    
    List<Lead> leadNames = new List<Lead>();
    List<Lead> leadToUpdate = new List<Lead>();
    for(Lead lead: Trigger.new){
        if(String.isEmpty(lead.FirstName)){
            leadNames.add(lead);
        }
    }
    
    for(Lead l : leadNames){
        
    }

}