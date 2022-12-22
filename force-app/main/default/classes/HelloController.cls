public class HelloController {
    public String objName{get;set;}
	public String[] fieldNames{get;set;}
	list<sObject> con = new list<sObject>();

	
	public HelloController(){
		RecordsPerPageslist = 10;
	}

	public String query;
	public String alphaSearchConct{get;set;}
	public string msg {get;set;}
	public Map<id,Boolean> m = new Map<id,boolean>(); 
	list<sObject> sortedList;
	public String myOrder{get;set;}                 // Ascending or Descending order of sorting
	public String sortField{get;set;}               // Field by which sorting should be done
	public boolean selectAll{get;set;}
	public list<String> alphabet{get;set;}
	public list<sObject> cont;
	public list<wrapper> allContactList = new list<wrapper>();
	public void fieldvalues(){
		query = fieldNames[0] + ' , ';
		for(Integer i=1;i<fieldNames.size();i++){
			query = query + fieldNames[i] + ' , ';
		}
		query='SELECT ' + query + ' FROM ' + 'objName';
	}
	public Integer RecordsPerPageslist{ 
        get;
        set{                                                          //To select number of records per page
            if(value!=null){
                this.RecordsPerPagesList=value;
                System.debug('RecordsPerPageList called');
            }
        }       
    }  
    public ApexPages.StandardSetController stdSetController{            //Instantiating a standard set controller
          get{
              if(stdSetController==null){
                    con = Database.query(query);
                    System.debug('con in ssc is : ' + con);
                   stdSetController = new ApexPages.StandardSetController(con);
              }
                stdSetController.setPageSize(RecordsPerPageslist);        //Limiting Number of records to be displayed per page 
                  System.debug('stdSetController called ');
              return stdSetController;   
          }
          set;
      }
    public list<wrapper> getWrapperContacts(){      //List of wrapper class to display in table
       for(sObject c:(list<sObject>)stdSetController.getRecords()){
       		allContactList.add(new wrapper(c));
       }
        return allContactList;
    }

    public class wrapper{
	  public boolean isSelected{get;set;}  
	  public sObject con{get;set;}  
	  public   wrapper(sObject con){
	          System.debug('constructor of wrapper class called ');
	          isSelected = false;
	          this.con = con;
	          }
	          
	      }
    
}