import { api, LightningElement } from 'lwc';
 
export default class ParentLwc extends LightningElement {

    @api evtMessage;
    value = 'This message is from Parent ';
    connectedCallback(){
        console.log("Parent component");
        this.template.addEventListener('btnclick', this.handleClick.bind(this));
    }

    handleClick(event){
        console.log("event.detail: ", JSON.stringify(event.detail));
        console.log("event.message: ", JSON.stringify(event.message));
        this.evtMessage = event.detail;
    }

    handleSendData(){
        console.log('Am in parent component');        
    }

}