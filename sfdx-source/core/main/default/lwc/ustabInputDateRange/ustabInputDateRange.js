/*
 * Date range picker component.
 *
 * Created by Yurii Heorhiiev on 04.08.2022.
 * <savthe217@gmail.com>
 */

import {LightningElement, api} from 'lwc';
import labelStartDate from '@salesforce/label/c.labelStartDate';
import labelEndDate from '@salesforce/label/c.labelEndDate';

export default class UstabInputDateRange extends LightningElement {
    label = {
        labelStartDate, labelEndDate
    };

    _maxRange = 31;
    _startDate;
    _endDate;

    /**
     * Maximum difference between start date and end date in days.
     */
    @api
    set maxRange(value) {
        if (isNaN(value)) {
            return;
        }

        value = parseInt(value, 10);

        if (value < 1) {
            value = 1;
        }

        this._maxRange = value;
    }

    get maxRange() {
        return this._maxRange;
    }

    @api
    set startDate(value) {
        this._startDate = value;
        this.fitDateInRange(true);
    }

    get startDate() {
        return this._startDate;
    }

    @api
    set endDate(value) {
        this._endDate = value;
        this.fitDateInRange(false);
    }

    get endDate() {
        return this._endDate;
    }

    onStartChange(event) {
        event.stopPropagation();

        this.startDate = event.target.value;
        this.dispatchChange();
    }

    onEndChange(event) {
        event.stopPropagation();

        this.endDate = event.target.value;
        this.dispatchChange();
    }

    /**
     * Throws 'change' event to parent components.
     */
    dispatchChange() {
        const {startDate, endDate} = this;

        this.dispatchEvent(
            new CustomEvent('change', {
                detail: {
                    startDate, endDate
                }
            })
        );
    }

    /**
     * If date is out of max range this function will fix the end date to max available from the start date.
     *
     * @param isStartDateChange
     */
    fitDateInRange(isStartDateChange) {
        const {startDate, endDate, maxRange} = this;

        if (startDate == null || endDate == null) {
            return;
        }

        let isoStartDate = new Date(startDate);
        let isoEndDate = new Date(endDate);
        const daysDifference = (isoEndDate - isoStartDate) / (1000 * 60 * 60 * 24);

        if (daysDifference < 0 || daysDifference > maxRange) {
            if (isStartDateChange) {
                isoStartDate.setDate(isoStartDate.getDate() + maxRange);
                this._endDate = isoStartDate.toISOString().slice(0, 10);
                const endDateInput = this.template.querySelector('.end-date');

                if (endDateInput != null) {
                    endDateInput.value = this._endDate;
                }
            } else {
                isoEndDate.setDate(isoEndDate.getDate() - maxRange);
                this._startDate = isoEndDate.toISOString().slice(0, 10);
                const startDateInput = this.template.querySelector('.start-date');

                if (startDateInput != null) {
                    startDateInput.value = this._startDate;
                }
            }
        }
    }
}