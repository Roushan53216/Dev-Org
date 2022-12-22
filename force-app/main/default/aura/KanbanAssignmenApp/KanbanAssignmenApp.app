<aura:application extends="force:slds">
	<c:KanbanAssignmentComponent objName="Opportunity" 
                                 objFields="['Name', 'AccountId', 'Account.Name', 'CloseDate', 'StageName', 'Amount']" 
                                 kanbanPicklistField="StageName"/> 
</aura:application>