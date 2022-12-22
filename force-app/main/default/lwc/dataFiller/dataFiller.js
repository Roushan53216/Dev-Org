import { LightningElement,api } from 'lwc';
 
export default class DataFiller extends LightningElement {
    name;
    phone;
    country;
    @api datTosend;

    getName(event){
        this.name = event.target.value;
    }
    getPhone(event){
        this.phone = event.target.value;
    }
    getCountry(event){
        this.country = event.target.value;
    }
    sendData(){
        this.datTosend = [{
            name : this.name,
            phone : this.phone,
            country : this.country 
        }]
        console.log('data : '+this.datTosend);
        console.log('fii '+this.datTosend);
        const sendDataEvent = new CustomEvent('collecteddata', 
        { detail: this.datTosend });

        // Dispatches the event.
        this.dispatchEvent(sendDataEvent);

    }

}