import { api, LightningElement,wire  } from 'lwc';
import getContact from '@salesforce/apex/lWCDemo.getContact';
import getAccount from '@salesforce/apex/lWCDemo.getAccount';
import getAccountFromKeyword from '@salesforce/apex/lWCDemo.getAccountFromKeyword';
import { NavigationMixin } from 'lightning/navigation';



const columns = [ { label: 'FirstName', fieldName: 'FirstName', sortable: "true"},
                  { label: 'LastName', fieldName: 'LastName', sortable: "true"},
                  { label: 'Phone', fieldName: 'Phone', type: 'phone', sortable: "true"},
                  { label: 'Email', fieldName: 'Email', type: 'email', sortable: "true" },];

 
export default class LWCFirstDemo extends NavigationMixin(LightningElement) {
    @api cloumn = columns; 
    message = 'Hello FROM JS ';
    input = '';
    @api sendMessage = 'This message sending'; 
    @api results;
    error;
    recordId = '0015j00000WKBLiAAP';


    handleClick(event){
        this.input = event.target.value;
    }
    
    callChild(event){
        this.message = 'Message Updated';
    }
    callChildMethod(event){
        this.message = 'Value From Parent Method to Child Method';
        this.template.querySelector('c-child-l-w-c-demo').childMethod(this.message);
    }

    @wire(getContact)
    getContactss ({error, data}) {
        if (error) {
            // TODO: Error handling
            this.error = error;
            window.console.log('error' +error);
            
        } else if (data) {
            // TODO: Data handling
            this.results = data;
        }
    }
    getAcc(){
        getAccount()
            .then(result => {
                this.results = result;
                
            })
            .catch(error => {
                // TODO Error handling
                this.error = error;
            });
    }

    getAccounts(event){
        this.input = event.target.value;
        getAccountFromKeyword({searchKeyword : this.input})
            .then(result => {
                this.results = result;
            })
            .catch(error => {
                // TODO Error handling
            });

    }

    handleChildEvent(event){
        let keyy = event.detail.keyss;
        let value = event.detail.value;
        this.message = keyy + ' from Child '+ value;
    }

    handleNavigation(){
        console.log('Heelo Nav');
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                actionName: "home",
                objectApiName: "Account"
            }
        });
    }


}