global class SetupAuditBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
    List<SetupAuditTrail> setupTrailList = new List<SetupAuditTrail>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT CreatedBy.Name,Action, Section, CreatedDate, 
                                        Display, DelegateUser, ResponsibleNamespacePrefix, CreatedByContext, CreatedByIssuer 
                                        FROM SetupAuditTrail WHERE CreatedDate = LAST_N_DAYS:30 ]);
    }
    global void execute(Database.BatchableContext BC,List<SetupAuditTrail> AuditTraiList){
        for(SetupAuditTrail setUp : AuditTraiList){
            setupTrailList.add(setUp);   
        }
        System.debug(setupTrailList);
    }
    global void finish(Database.BatchableContext BC){
        //Date dat = System.today().Year();
        Integer currentYear = System.today().Year(); 
        Integer LastMonth = System.today().Month() - 1;
        String fileName = 'Setup Audit Trail of Month ' +LastMonth+'/'+currentYear +'.csv';
        System.debug(fileName);
        String recordString ; 
        String finalRecordString = 'Name,Action, Section, CreatedDate, Display, DelegateUser, ResponsibleNamespacePrefix, CreatedByContext, CreatedByIssuer \n';
        String eMails = System.Label.Emails_For_Setup_Audit_Trail_Batch_Class; 

        Messaging.SingleEmailMessage sinMail = new messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
        if(!setupTrailList.isEmpty()){
            for(SetupAuditTrail setUptrail : setupTrailList){
                recordString = '"'+setUptrail.CreatedBy.Name + '","' + setUptrail.Action + '","' + setUptrail.CreatedBy.Name + '","' + setUptrail.CreatedDate + '","' +setUptrail.Display + '","' +setUptrail.DelegateUser + '","' +setUptrail.ResponsibleNamespacePrefix + '","' + setUptrail.CreatedByContext + '","' + setUptrail.CreatedByIssuer + '","' + '"\n';
                recordString = recordString.replace('null',' ');
                System.debug(recordString); 
                finalRecordString = finalRecordString + recordString ; 
            }
            System.debug('###'+finalRecordString);
        }
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(fileName);
                    efa.setBody(Blob.valueOf(finalRecordString));
                    emailAttList.add(efa);
        
        String[] toAddress = new String[]{};            
        if(eMails != null){
            toAddress = eMails.split(',');
        }
        sinMail.setToAddresses(toAddress);
        sinMail.setSubject('VGA-Setup Audit Trail For Month ' +LastMonth+'/'+currentYear);
        sinMail.setPlainTextBody('Please , Find the Attachment For Last Month Audit Trail ');
        sinMail.setFileAttachments(emailAttList);
        Messaging.sendEmail(new messaging.SingleEmailMessage[]{sinMail});
    }
    global void execute(SchedulableContext sc){
        SetupAuditBatch setupAudit = new SetupAuditBatch();
        Database.executebatch(setupAudit,2000); 
    }
    //String str = '0 0 10 1 * ? *'; 
    //System.Schedule('AuditTrail Schedule 1',str,setupAudit);
    
    
}