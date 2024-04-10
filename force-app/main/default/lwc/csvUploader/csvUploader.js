import { LightningElement, api, track } from 'lwc';
import importBulkdata from '@salesforce/apex/BulkAPIUtility.importBulkdata';

export default class CsvUploader extends LightningElement {

    @api recordId; // Use this attribute to specify the record where the file should be attached
    acceptedFormats = ['.csv'];
    @track showToast = false;
    @track showSpinner = false;

    async handleUploadFinished(event) {
        // Get the list of uploaded files
        try {
            debugger;
            const uploadedFiles = event.detail.files;
            let uploadData = [{ fileIdList: [uploadedFiles[0].documentId], objectName: 'SQX_Part__c', operation: 'upsert' }];
            let result = await importBulkdata({ dataWrapperList: uploadData,jsonData :  JSON.stringify(uploadData)})
            this.showSpinner = true;
            setTimeout(() => {
                this.showSpinner = false;
                this.showToast = true;
            }, 1000);
            setTimeout(() => {
                this.showToast = false;
            }, 5000);
        }
        catch (error) {
        }
    }
}