import { LightningElement, track } from 'lwc';
 
export default class PersonTable extends LightningElement {
    data=[];
    @track hell=[];
    columns = [
        { label: 'Name', fieldName: 'name' },
        { label: 'Phone', fieldName: 'phone', type: 'phone' },
        { label: 'Country', fieldName: 'country', type: 'text' }
        
    ]; 

    collectData(event){
        var incomingData = JSON.parse(JSON.stringify(event.detail));
        this.hell = event.detail;
        //this.data = incomingData;
        //this.data.push(...incomingData);
        let newEntry =[];
         /*{
            'name' : incomingData.name,
            'phone' : incomingData.phone,
            'country' : incomingData.country     
        };*/
        console.log('name ==>> '+incomingData.name);
        console.log('DETAIL=====>>> '+JSON.stringify(event.detail)); 
        console.log('DETAIL=====>>> '+event.detail.name);
        for(let key in incomingData){
            console.log('loop : '+incomingData[key]);
            var getVal = {
                name : incomingData[key].name,
                phone : incomingData[key].phone,
                country : incomingData[key].country
            };
            newEntry.push(getVal);
        }
        console.log('iinn : '+newEntry);
        if(this.data){
            this.data = [...this.data,newEntry];
        }
        else{
            this.data = [newEntry];
        }
        console.log('===>> '+JSON.stringify(this.data));
    }
}