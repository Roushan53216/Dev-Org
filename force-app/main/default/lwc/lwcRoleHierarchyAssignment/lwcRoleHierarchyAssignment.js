import { LightningElement, wire, track,api } from 'lwc';
import getRoles from '@salesforce/apex/RoleHeirarchyController.getRoles';
import getUsers from '@salesforce/apex/RoleHeirarchyController.getUsers';
 
export default class LwcRoleHierarchyAssignment extends LightningElement {
    @track roles;
    @track error;
    isModalOpen ;
    users ;

    @wire(getRoles)
    wiredRoles({ error, data }) {
        if (data) {
            this.roles = JSON.parse(data);
            this.error = undefined;
            console.log(this.roles);
        } else if (error) {
            this.error = error;
            this.roles = undefined;
            console.log(error);
        }
    }
    getUser(event){
        getUsers({roleName : event.detail.name})
            .then(result => {
                this.users = result;
                
            })
            .catch(error => {
                // TODO Error handling
                this.error = error;
            });
        //this.users = event.detail.name;
        console.log(event.detail.name);
        this.isModalOpen = true; 
    }
    closeModal(){
        this.isModalOpen = false;
    }


  

}