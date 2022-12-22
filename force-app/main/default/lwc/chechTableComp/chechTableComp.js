import { LightningElement,wire,track } from 'lwc';
import getAllrecords from '@salesforce/apex/LWCPaginitionController.demoAcc';




export default class ChechTableComp extends LightningElement {

    @track error;



    columns=[



        {label: 'Account Name', fieldName: 'Account_URL', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'} },
        
        
        
        {label: 'Account Industry', fieldName: 'Industry'},
        
        
        
        {label: 'Account Description', fieldName: 'Description'},
        
        
        
        ];



    @track accList;



    @wire (getAllrecords) getAllrecor({error, data})



    {




        if(data)



        {



            let accParsedData=JSON.parse(JSON.stringify(data));
            console.log('tabbbb ==>> '+JSON.stringify(data));



            let baseUrlOfOrg=  window.location.origin+'/';



            accParsedData.forEach(acc => {



                if(acc.Id){



                //acc.Parent_Account_Name=acc.Parent.Name;



                acc.Account_URL=baseUrlOfOrg+acc.Id;



                }



            });



            this.accList = accParsedData;



        }



        else if(error)



        {

            this.error = error;
            console.log('errorr  :   ==>>  '+JSON.stringify(this.error));

        }

    }

}