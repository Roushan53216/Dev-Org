import { api, LightningElement } from 'lwc';
 
export default class GrandChildLwc extends LightningElement {

    @api evtMessage = 'Grand Child component event is triggered. ';
    @api mess = 'Hello Message ';

    connectedCallback(){
        console.log("Grand Child component");
    }

    handleClick(event){
        this.dispatchEvent(new CustomEvent('btnclick', { bubbles: true , composed : true, detail: this.evtMessage }));
    }

}