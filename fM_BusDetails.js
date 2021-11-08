import { LightningElement,track } from 'lwc';
import getBusDetails from '@salesforce/apex/FM_BusDetailsController.getBusDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class FM_BusDetails extends LightningElement {

    @track buses=[];
    @track busMap = new Map();
    @track year;
    @track maxCapacity;
    @track Odometer;
    @track resaleValue;
    @track showDetails = false;
    @track editDetails = false;
    @track selectedId='';
    objectApiName= 'Bus__c';
    

    connectedCallback(){
        this.getBusInfo();
    }
    getBusInfo(){
        getBusDetails()
                .then(result => {  
                    console.log('** result' + JSON.stringify(result));
                    let busesMap = new Map();
                    for (let i = 0; i < result.length; i++) {
                        busesMap[result[i].Id] = result[i];
                    }
                    this.buses =result;
                    this.busMap = busesMap;
                   
                   
            })
            .catch(error => {
                console.log('** error' + error);
                console.log('** error' + JSON.stringify(error));
            });
    }
    handleClick(event){
        this.showDetails = true;
        this.editDetails = false;
        let index = event.currentTarget.dataset.id;
        this.selectedId = index;
        let record = this.busMap[index];
        this.year = record.Year__c;
        this.maxCapacity = record.Maximum_Capacity__c;
        this.Odometer = record.OdometerReading__c;
        this.resaleValue = record.Resale_Value__c;

    }
    handleEditClick(){
        this.showDetails = false;
        this.editDetails = true; 
    }
    handleSaveClick(){
       let recordId = this.selectedId;
        console.log(this.year);

    }
    handleYearChange(event){
        this.year = event.detail.value;
    }
    handleCapacityChange(event){
        this.maxCapacity = event.detail.value;
    }
    handleOdometerChange(event){
        this.Odometer = event.detail.value;
    }
    handleSuccess(event){
      
        const payload = event.detail;
        let recordId = event.detail.id;
        if(recordId != null){
        this.dispatchEvent(new ShowToastEvent({
            title: "SUCCESS!",
            message: "Record has been updated.",
           variant: "success",
        }),  
   );
        this.year = event.detail.fields.Year__c.value;
        this.maxCapacity = event.detail.fields.Maximum_Capacity__c.value;
        this.Odometer = event.detail.fields.OdometerReading__c.value;
        this.resaleValue = event.detail.fields.Resale_Value__c.value;
        this.showDetails = true;
        this.editDetails = false; 
    }
    }
    handleCancel(){
        this.showDetails = false;
        this.editDetails = false;  
    }
    handleSaveCancel(){
        this.showDetails = true;
        this.editDetails = false;  
    }

}