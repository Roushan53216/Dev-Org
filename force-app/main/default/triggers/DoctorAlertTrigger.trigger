trigger DoctorAlertTrigger on Patient__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(trigger.isAfter && trigger.isInsert){
        AlertDoctorTriggerHelper.alertDoctor(trigger.new);

    }
    
}