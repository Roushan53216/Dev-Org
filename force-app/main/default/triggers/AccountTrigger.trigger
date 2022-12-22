trigger AccountTrigger on Account (before insert) {
	AccountTriggerHelper.totalSum(Trigger.New); 
}