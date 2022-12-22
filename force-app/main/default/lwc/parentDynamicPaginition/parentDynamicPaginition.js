import { LightningElement,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllrecords from '@salesforce/apex/LWCPaginitionController.getAllRecords';
import getFilterFields from '@salesforce/apex/LWCPaginitionController.checkFieldTypeForFilter';
 
export default class ParentDynamicPaginition extends NavigationMixin(LightningElement) {
    selectedObject;
    selectedFeilds;
    columns;
    records;
    pageNumber=1;
    totalPages ;
    totalRecords = 1;
    pageSizeOptions = [10,25,50,100];
    bDisableFirst;
    noOfRecord = 10;
    bDisableLast;
    showTable = false;
    totalNumOfRecords;
    firstFeild;
    selection = [];
    firstRecordId = '';
    lastRecordId = '';
    sortBy;
    sortDirection='';
    lastRecName;
    firstRecName;
    queryAbleFileds;
    selectedFilterField;
    showFilterSction;
    nameFilterFields=[];
    phoneFilterFields=[];
    numberFilterFields=[];
    dateFilterFields=[];
    dateTimeFilterFields=[];
    pickListFeilds = [];
    whereClauseQueryString = '';
    clear;

    connectedCallback(){
        if(this.pageNumber == 1){
            this.bDisableFirst = true;
        }
        
    }


    // getting All the data from Custom Event
    getAllChildData(event){
        this.columns = event.detail.columns;
        this.records = event.detail.records ;
        this.selectedObject = event.detail.selectedObject;
        this.selectedFeilds = event.detail.selectedFeilds;
        this.queryAbleFileds = event.detail.queryablefeilds;
        this.totalNumOfRecords = event.detail.totalNumOfRecords;
        this.firstFeild = event.detail.firstFeild;
        this.sortBy = event.detail.firstFeild;
        this.showTable = true;
        this.totalPages = Math.floor(this.totalNumOfRecords / this.noOfRecord)+1;
        console.log('cols : ' + this.columns);
        console.log('recs : '+ this.records);

    }

    handleFilterChange(event){
        this.selectedFilterField = [];
        this.selectedFilterField = event.detail.value;
        console.log(this.selectedFilterField);

        getFilterFields({selectedObj:this.selectedObject,selectedFeilds:this.selectedFilterField})
        .then(result => {
            var nameFld = [];
            var phoneFld = [];
            var numberFld= [];
            var dateFld = [];
            var dateTimeFls= [];
            var picVals = [];
            for(let i in result.stringFields){
                nameFld.push({label:result.stringFields[i],value:result.stringFields[i]});
                console.log('string === ');
            }
            this.nameFilterFields = nameFld;
            for(let i in result.phoneFields){
                nameFld.push({label:result.phoneFields[i],value:result.phoneFields[i]});
            }
            this.phoneFilterFields = phoneFld;
            for(let i in result.numberFields){
                numberFld.push({label:result.numberFields[i],value:result.numberFields[i]});
            }
            this.numberFilterFields = numberFld;
            for(let i in result.dateFields){
                dateFld.push({label:result.dateFields[i],value:result.dateFields[i]});
            }
            this.dateFilterFields = dateFld;
            for(let i in result.dateTimeFields){
                dateTimeFls.push({label:result.dateTimeFields[i],value:result.dateTimeFields[i]});
            }
            this.dateTimeFilterFields = dateTimeFls;
            for(let key in result.allPicklistFieldsValues){
                var tempVar = [];
                for(let i in result.allPicklistFieldsValues[key]){
                    tempVar.push({label : result.allPicklistFieldsValues[key][i] , value : result.allPicklistFieldsValues[key][i]});
                }
                picVals.push({key:key, value:tempVar});
            }
            this.pickListFeilds = picVals;
            console.log(JSON.stringify(result));
            
        })
        .catch(error => {
            this.error = error;
        });
        this.showFilterSction = true;
        
    }

    handleFilter(){
        console.log('filter');
    }
    handleClearFilter(){
        console.log('clear filter'); 
        //this.clear='';
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if(element.type === 'checkbox' || element.type === 'checkbox-button'){
              element.checked = false;
            }else{
              element.value = null;
            }      
        });
    }

    handleNameFilterChange(event){
        console.log("==>>> "+event.target.value);
        this.whereClauseQueryString += event.target.label + ' = ' + event.target.value;
        console.log('query======>>>  '+this.whereClauseQueryString);
    }
    handlePhoneFilterChange(event){
        console.log("==>>>##$$  "+event.target.value);
    }
    handlePickValChange(event){
        console.log('pickVal ==>> '+event.target.value);
    }

    nextPage(){
        var sizz = this.records.length;
        var feildName = this.firstFeild;
        this.firstRecordId = '';
        this.lastRecordId = this.records[sizz-1].Id;
        console.log('size of Object ==... '+sizz);
        this.pageNumber = this.pageNumber+1;
        this.lastRecName =( this.records[sizz-1][this.sortBy])?this.records[sizz-1][this.sortBy] : '';
        this.getRecords();
        console.log('id : '+this.lastRecordId);
        console.log('Name : '+this.lastRecName);
        this.bDisableFirst = false;
    }
    previousPage(){
        console.log();
        this.firstRecordId = this.records[0].Id;
        this.lastRecordId = '';
        this.pageNumber = this.pageNumber-1;
        console.log('perviousssss  ');
        this.firstRecName = ( this.records[0][this.sortBy]) ? this.records[0][this.sortBy] : '' ;
        console.log('------- '+JSON.stringify(this.records[0][this.sortBy]));
        this.getRecords();
        if(this.pageNumber == 1){
            this.bDisableFirst = true;
        }
        this.bDisableLast = false;
    }
    firstPage(){
        this.firstRecordId = '';
        this.lastRecordId = '';
        this.pageNumber = 1;
        this.getRecords();
        this.bDisableFirst = true;
        this.bDisableLast= false;
    }
    lastPage(){
        this.firstRecordId = 'last';
        this.lastRecordId = 'last';
        this.pageNumber = this.totalPages;
        var holdPreviousRecNo = this.noOfRecord;
        this.noOfRecord = this.totalNumOfRecords -((Math.floor(this.totalNumOfRecords / this.noOfRecord))*this.noOfRecord);
        this.getRecords();
        this.noOfRecord = holdPreviousRecNo;
        this.bDisableLast= true;
        this.bDisableFirst = false;
    }
    handleRecordsPerPage(event){
        var sizz = this.records.length;
        this.noOfRecord = event.target.value;
        this.firstRecordId = '';
        this.lastRecordId = '';
        this.totalPages = Math.floor(this.totalNumOfRecords / this.noOfRecord);
        this.getRecords();

    }

    // Column Sorting
    handleSortRecordData(event) {       
        this.sortBy = event.detail.fieldName;       
        this.sortDirection = event.detail.sortDirection;  
        console.log(this.sortBy);
        console.log(this.sortDirection);
        this.firstRecordId = '';
        this.lastRecordId = '';
        this.pageNumber = 1;
        this.getRecords();
        //this.sortRecordData(event.detail.fieldName, event.detail.sortDirection);
    }


    // Getting Records From The Server 
    getRecords(){
        
        var args = {
            selectedFields : this.selectedFeilds,
            selectedObject:this.selectedObject,
            noOfRecord:this.noOfRecord,
            fristRecId:this.firstRecordId,
            lastRecId:this.lastRecordId,
            nameFeild:this.firstFeild,
            lastRecName:this.lastRecName,
            firstRecName:this.firstRecName,
            sortByFeild:this.sortBy,
            sortDirection:this.sortDirection
        };
        getAllrecords({selectedFields : this.selectedFeilds,selectedObject:this.selectedObject,noOfRecord:this.noOfRecord,fristRecId:this.firstRecordId,lastRecId:this.lastRecordId,nameFeild:this.firstFeild,lastRecName:this.lastRecName,firstRecName:this.firstRecName,sortByFeild:this.sortBy,sortDirection:this.sortDirection})
        .then(result => {
            //this.records = result.records;
            let recs = JSON.parse(JSON.stringify(result.records));
            let baseUrlOfOrg=  window.location.origin+'/';

            recs.forEach(acc => {

                if(acc.Id){
                acc.nav_URL=baseUrlOfOrg+acc.Id;
                }

            });
            if(result.isPrevious || result.isLast){
                var sortRecords = [];
                for(let i = recs.length-1;i>=0;i--){
                    sortRecords.push(recs[i]);
                    //console.log('looppp '+recs[i]);
                }
                this.records = sortRecords;
                //console.log('prev '+JSON.stringify(this.records));
            }
            else{
                this.records = recs;
            }
            //this.records = recs;
            console.log('rec == '+result.records);
        })
        .catch(error => {
            this.error = error;
        });
        console.log('Records ===>>> '+ JSON.stringify(this.records));
        //console.log('Reco ===>>> '+ JSON.stringify(this.records));

    }



}

/*
rowSelection(event) {
        // List of selected items from the data table event.
        let updatedItemsSet = new Set();
        // List of selected items we maintain.
        let selectedItemsSet = new Set(this.selection);
        // List of items currently loaded for the current view.
        let loadedItemsSet = new Set();
        this.records.map((event) => {
            loadedItemsSet.add(event.Id);
        });
        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((event) => {
                updatedItemsSet.add(event.Id);
            });
            // Add any new items to the selection list
            updatedItemsSet.forEach((id) => {
                if (!selectedItemsSet.has(id)) {
                    selectedItemsSet.add(id);
                }
            });        
        }
        loadedItemsSet.forEach((id) => {
            if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                // Remove any items that were unselected.
                selectedItemsSet.delete(id);
            }
        });
    
    
        this.selection = [...selectedItemsSet];
        //console.log('---selection---'+JSON.stringify(this.selection));
        
      }
*/