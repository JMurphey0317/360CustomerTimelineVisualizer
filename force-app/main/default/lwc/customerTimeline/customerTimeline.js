import { LightningElement, api, wire } from 'lwc';
import getTimelineEvents from '@salesforce/apex/CustomerTimelineController.getTimelineEvents';

export default class CustomerTimeline extends LightningElement {
    @api recordId;
    timelineData;
    error;

    @wire(getTimelineEvents, { recordId: '$recordId' })
    wiredData({ error, data }) {
        if (data) {
            this.timelineData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body.message;
            this.timelineData = undefined;
        }
    }
}