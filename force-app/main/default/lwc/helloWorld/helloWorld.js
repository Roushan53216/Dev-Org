import { LightningElement, wire,api } from 'lwc';
import promiseMethod1 from '@salesforce/apex/PromiseExmp.method1';
import promiseMethod2 from '@salesforce/apex/PromiseExmp.method2';
import promiseMethod3 from '@salesforce/apex/PromiseExmp.method3';

 
export default class HelloWorld extends LightningElement {
    @api recordId;
    str1 = 'Waiting......';
    str2 = 'Still Waiting.....'; 

    
    output = "Waiting...";
    connectedCallback() {}
    async asyncCall(event) {
    this.output = "Waiting..."; 
    this.output = await promiseMethod1();
    this.output = await promiseMethod2({ param: this.output }); 
    }
    promiseCall(event) {
    this.output = "Waiting...";
    promiseMethod1()
        .then((result) => ((this.output = result), promiseMethod2({ param: result })))
        .then((result) => (this.output = result));
    }
    

    async callBothMethod(){
        await this.callfirst();
        await this.callSecond();  

        
        
    }

    callfrompromise(){
        promiseMethod1()
        .then((result) => ((this.str1 = result), promiseMethod2({ param: result })))
        .then((result) => (this.str2 = result));

    }

    callfirst(){
        promiseMethod1()
            .then(result => {
                this.str1 = result;
                
            })
            .catch(error => {
                // TODO Error handling
                this.error = error;
            });

    }

    callSecond(){
        promiseMethod2({param:this.str1})
            .then(result => {
                this.str2 = result;
                console.log('11');
                
            })
            .catch(error => {
                // TODO Error handling
                this.error = error;
                console.log('111');
            });
    }

}