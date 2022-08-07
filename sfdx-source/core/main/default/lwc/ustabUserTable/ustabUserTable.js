/*
 * Sales users stats table.
 *
 * Created by Yurii Heorhiiev on 02.08.2022.
 * <savthe217@gmail.com>
 */

import {LightningElement, track, wire} from 'lwc';
import getSalesUsers from '@salesforce/apex/ustab_SalesUserService.getSalesUsers';
import {UtilsMixin} from 'c/ustabUtils';
import columns from './columns';
import labelsImport from './labels';

const MAX_DATE_RANGE = 31;

export default class UstabUserTable extends UtilsMixin(LightningElement) {
    startDate;
    endDate;
    columns = columns;
    sortBy = 'ownerName';
    sortDirection = 'asc';
    isLoading = true;
    labels = labelsImport;

    @track
    items;

    constructor() {
        super();
        let today = new Date();

        this.endDate = today.toISOString().slice(0, 10);
        today.setDate(today.getDate() - MAX_DATE_RANGE);
        this.startDate = today.toISOString().slice(0, 10);
    }

    get maxDateRange() {
        return MAX_DATE_RANGE;
    }

    @wire(getSalesUsers, {
        startDate: '$startDate',
        endDate: '$endDate',
        sortBy: '$sortBy',
        sortOrder: '$sortDirection'
    })
    getItems(payload) {
        const {error, data} = payload;

        if (error) {
            this[UtilsMixin.HandleErrors](error);
        } else if (data) {
            this.items = data;
        }

        this.isLoading = false;
    }

    onDateRangeChange(event) {
        const {startDate, endDate} = event.detail;


        if (this.startDate === startDate && this.endDate === endDate) {
            return;
        }

        this.isLoading = true;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    onColumnSort(event) {
        const { fieldName, sortDirection } = event.detail;

        this.isLoading = true;
        this.sortBy = fieldName;
        this.sortDirection = sortDirection;
    }
}