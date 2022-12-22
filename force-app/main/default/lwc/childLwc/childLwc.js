import { api, LightningElement } from 'lwc';
 
export default class ChildLwc extends LightningElement {

    @api message;

    connectedCallback(){
        console.log("Child component");
    }

    handleSendData(){
        console.log('Am in child component');        
    }
    handleSendData1(){
        console.log('Am in child componentss 1 ');        
    }
    
    handleClick(){
        this.template.querySelector('.buttonDiv')
                .dispatchEvent(
                    new CustomEvent('senddata', {bubbles: true, composed: false})
                );
    }

}