import { LightningElement } from 'lwc';
 
export default class FilterForDynamicPaginition extends LightningElement {


    handleFilterChange(event){
        this.selectedFilterField = [];
        this.selectedFilterField = event.detail.value;
        console.log(this.selectedFilterField);

        getFilterFields({selectedObj:this.selectedObject,selectedFeilds:this.selectedFilterField})
        .then(result => {
            console.log(JSON.stringify(result));
            
        })
        .catch(error => {
            this.error = error;
        });
        
    }
}