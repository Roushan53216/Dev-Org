public with sharing class RecptionComoponentCtrl {

    @AuraEnabled
    public static getDetails getDepartmantName(){
        getDetails details = new getDetails();
        try {
            details.departmentName = getPicklistValues('Patient__c','Department_To_Admit__c');

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return details;
    }

    @AuraEnabled
    public static List<DoctorsValues> getAllDoctors(String department){
        
        List<DoctorsValues> allDoctors = new List<DoctorsValues>();
        try {
            List<Doctor__c> doctorsList = [SELECT Id,Name From Doctor__c Where Department__c =: department];
            for(Doctor__c doctor : doctorsList){
                allDoctors.add(new DoctorsValues(doctor.Name,doctor.Id));
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage()); 
        }
        return allDoctors;
    }

    @AuraEnabled
    public static void insertPatient(String Name,Date AppointmentDate,String departmentToAdmit, String appointmentTime,String doctor ){
        try {
            Patient__c patient = new Patient__c();
            patient.Name = Name;
            patient.Appointment_Date__c = AppointmentDate;
            patient.Department_To_Admit__c = departmentToAdmit;
            //patient.Appointment_Time__c = appointmentTime;
            patient.Doctor__c = doctor;
            insert patient;
            
        } catch (Exception e) {
            //System.debug('Exception ');
            throw new AuraHandledException(e.getMessage()+' '+e.getLineNumber());
            
        }
        //return state;
    }

    private static List<PicklistValues> getPicklistValues(String objectName,String picklistFeild){
        List<PicklistValues> pickValList = new List<PicklistValues>();
        //Map<String, String> mapPickListValues = new Map<String, String>();
        Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
        List<Schema.PicklistEntry> lstPickListValues = mapFields.get(picklistFeild).getDescribe().getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            pickValList.add(new PicklistValues(objPickList.getLabel(),objPickList.getValue()));
            //System.debug('Value = ' +objPickList.getValue() +' , Label = ' +objPickList.getLabel());
        }
        return pickValList;
    }

    public class getDetails{
        @AuraEnabled
        public List<PicklistValues> departmentName;
        //@AuraEnabled
        //public List<PicklistValues> doctorsName;
    }

    public class PicklistValues{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        public PicklistValues(String labl,String val){
            this.label = labl;
            this.value = val;
        }
    }
    public class DoctorsValues{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
        public DoctorsValues(String labl,String val){
            this.label = labl;
            this.value = val;
        }
    }



}