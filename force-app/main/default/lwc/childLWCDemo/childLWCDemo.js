import { LightningElement,api } from 'lwc';
 
export default class ChildLWCDemo extends LightningElement {
    @api messages; 

    handleChange(event){
        this.messages = event.target.value;  
    }

    
    @api childMethod(name){
        this.messages = name;
    }

    childToParent(){
        const event = new CustomEvent('btnclick', { 
            detail: { 
                keyss : 'abc',
                value : 'val'
             }
        });
        this.dispatchEvent(event);
    }


}