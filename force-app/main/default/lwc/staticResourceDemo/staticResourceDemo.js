import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import StaticCSS from '@salesforce/resourceUrl/StaticCSS';
import { loadStyle } from 'lightning/platformResourceLoader';



 
export default class StaticResourceDemo extends LightningElement {

    renderedCallback() {
        
        /*Promise.all([
            loadStyle( this, StaticCSS )
            ]).then(() => {
                console.log( 'Files loaded' );
            })
            .catch(error => {
                console.log( error.body.message );
        });*/

    }



}