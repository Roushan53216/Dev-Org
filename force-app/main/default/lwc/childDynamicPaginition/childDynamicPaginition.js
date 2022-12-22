import { LightningElement,api } from 'lwc';
import getAllObjects from '@salesforce/apex/LWCPaginitionController.getAllObjects';
import getAllFeilds from '@salesforce/apex/LWCPaginitionController.getAllFeildsOfSelectedObj';
import getAllrecords from '@salesforce/apex/LWCPaginitionController.getAllRecords';

export default class ChildDynamicPaginition extends LightningElement {
    allObjects;
    selectedObject;
    allFeilds;
    selectedFeilds;
    columns;
    records=[];
    noOfRecord = 10;
    offSet = 0;
    showFeilds = false;
    totalNumOfRecords;
    orgBaseURL;
    firstNameFeild;
    firstRecordId;
    sortOrder='ASC';
    queryableFeilds;


    connectedCallback(){

        //getting base org URL for record Navigation 
        this.orgBaseURL =  window.location.origin;
        //console.log('url : '+this.orgBaseURL);

        // Getting All The Objects From The Org
        getAllObjects()
        .then(result => {
            var obj = [];
            for(let i in result){
                obj.push({label:result[i],value:result[i]});
            }
            this.allObjects = obj;
        })
        .catch(error => {
            this.error = error;
        });



    }

    // Getting All thr Feilds of Selested Object
    handleObjectChange(event){
        this.selectedObject = event.target.value;
        this.selectedFeilds = [];
        //console.log('Selectd Obj : '+this.selectedObject);
        //console.log('Selectd Obj : '+this.selectedFeilds);

        getAllFeilds({selectedObject : this.selectedObject})
        .then(result => {
            this.firstNameFeild = result.nameFeild;
            var obj = [];
            for(let i in result.allFeilds){
                obj.push({label:result.allFeilds[i],value:result.allFeilds[i]});
            }
            this.allFeilds = obj;
            var feild = [];
            for(let i in result.qureyableField){
                feild.push({label:result.qureyableField[i],value:result.qureyableField[i]});
            }
            this.queryableFeilds = feild;
        })
        .catch(error => {
            this.error = error;
            console.log(JSON.stringify(error));
        });
        this.showFeilds = true;

    }

    //Getting All The Selected Feilds and getiing all the reocrds
    async handleFeildChange(event){
        this.selectedFeilds = [];
        this.selectedFeilds = event.detail.value;
        var feilds=[{label:this.firstNameFeild,fieldName:'nav_URL',type: 'url', typeAttributes: { label: { fieldName: this.firstNameFeild } , target: '_blank' }}];
        var run = true;
        for(let i in this.selectedFeilds){
            feilds.push({label:this.selectedFeilds[i],fieldName:this.selectedFeilds[i],sortable: true});
        }
        this.columns = feilds;
        
        
        /*let promises = [];
		promises.push(this.getRecords());
		promises.push(this.sendChildDataToParent());
		Promise.all(promises).then(result => {
			console.log(`${JSON.stringify(result)}  Success`);
		});*/

        return new Promise(async (resolve, reject) =>{
            console.log('2');
            var result = await this.getRecords();
            console.log('3');
            resolve(result);
        });
        //this.getRecords();
        
        //await this.sendChildDataToParent();

    }

    showRecords(){
        this.sendChildDataToParent();
    }

    //getting the records
    getRecords(){//selectedFields : this.selectedFeilds,selectedObject:this.selectedObject,noOfRecord:this.noOfRecord,nameFeild:this.firstNameFeild,sortDirection:this.sortOrder,sortByFeild:this.firstNameFeild
        var jso = [{"selectedFields":this.selectedFeilds,
            "selectedObject" : this.selectedObject,
            "noOfRecord" : this.noOfRecord,
            "nameFeild" : this.firstNameFeild,
            "sortDirection" : this.sortOrder,
            "sortByFeild" : this.firstNameFeild
        }];
        getAllrecords({selectedFields : this.selectedFeilds,selectedObject:this.selectedObject,noOfRecord:this.noOfRecord,nameFeild:this.firstNameFeild,sortDirection:this.sortOrder,sortByFeild:this.firstNameFeild})
        .then(result => {
            //this.records = result.records;
            this.totalNumOfRecords = result.totalRecords;

            let recs = JSON.parse(JSON.stringify(result.records));
            let baseUrlOfOrg=  window.location.origin+'/';

            recs.forEach(acc => {
                if(acc.Id){
                acc.nav_URL=baseUrlOfOrg+acc.Id;
                }

            });
            this.records = recs;
        })
        .catch(error => {
            this.error = error;
            console.log(JSON.stringify(error));
        });
        console.log('Child Comp ======>>>>>>');
        console.log('Records ===>>> '+ this.records);
    }

    // sending Columns And Records To Parent 
    sendChildDataToParent(){
        const selectedEvent = new CustomEvent('send_data_to_parent', 
        { detail: {
            columns : this.columns,
            records : this.records, 
            selectedFeilds : this.selectedFeilds,
            selectedObject : this.selectedObject,
            totalNumOfRecords : this.totalNumOfRecords,
            firstFeild : this.firstNameFeild,
            queryablefeilds : this.queryableFeilds
            //allFeilds : this.allFeilds
        } });

        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }


}