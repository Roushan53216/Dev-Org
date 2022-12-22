public class PageBlockTableSortingCon {
    
    private List<Account> accounts;
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    
    public String getSortDirection()
    {
        //if not column is selected
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    public List<Account> getAccounts() {
        return accounts;
    }
    
    
    public PageReference ViewData() {
        //build the full sort expression
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        //System.debug(sortFullExp);
        
        //query the database based on the sort expression
        accounts = Database.query('Select id, Name, BillingCity, BillingCountry, Phone from Account order by ' + sortFullExp + ' limit 1000');
        return null;
    }
    
}

/* For sorting the Columns    
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    
    public String getSortDirection()
    {
        //if not column is selected
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    List<Account> accList {get;set;}
        
    public PageReference ViewData() {
        //build the full sort expression
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        
        //query the database based on the sort expression
        accList = Database.query('SELECT Name,Site,Type,Phone,OwnerId FROM Account ORDER BY ' + sortFullExp );
        return null;
    }
*/

/* <apex:facet name="header">   
                        <apex:commandLink action="{!sortValue}" value="Name" id="cmdSort">
                            <apex:param value="name" name="name" assignTo="{!columnValue}" ></apex:param>
                        </apex:commandLink>
                    </apex:facet> 
                     <apex:outputLink value="/{!acc.Id}" target="_blank">{!acc.Name}</apex:outputLink>

*/