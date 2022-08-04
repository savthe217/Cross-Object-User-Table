/*
 * This module contains commonly used utility functions.
 *
 * Created by Yurii Heorhiiev on 04.08.2022.
 * <savthe217@gmail.com>
 */

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

let UtilsMixin = (superClass) => {
    /**
     * Shows error message as toast. Can take response.getError() as argument.
     * @param errors
     */
    function handleErrors(errors) {
        let toastParams = {
            title: 'Error',
            message: 'Unknown error',
            variant: 'error'
        };

        errors = reduceErrors(errors);

        if (errors.length) {
            toastParams.message = errors.join(' ');
        }

        this.dispatchEvent(new ShowToastEvent(toastParams));
    }

    /**
     * Reduces one or more LDS errors into a string[] of error messages.
     * @param {FetchResponse|FetchResponse[]} errors
     * @return {String[]} Error messages
     */
    function reduceErrors(errors) {
        if (!Array.isArray(errors)) {
            errors = [errors];
        }

        return (
            errors
                .filter((error) => !!error)
                .map((error) => {
                    // UI API read errors
                    if (Array.isArray(error.body)) {
                        return error.body.map((e) => e.message);
                    }
                    // UI API DML, Apex and network errors
                    else if (error.body && typeof error.body.message === 'string') {
                        return error.body.message;
                    }
                    // JS errors
                    else if (typeof error.message === 'string') {
                        return error.message;
                    }
                    // Unknown error shape so try HTTP status text
                    return error.statusText;
                })
                // Flatten
                .reduce((prev, curr) => prev.concat(curr), [])
                // Remove empty strings
                .filter((message) => !!message)
        );
    }

    return class extends superClass {
        utils__handleErrors = handleErrors;
        utils__reduceErrors = reduceErrors;
    };
};

const apiMethods = {
    HandleErrors: 'utils__handleErrors',
    GetCookie: 'utils__getCookie',
    SetCookie: 'utils__setCookie',
    ReduceErrors: 'utils__reduceErrors',
    ShowSuccess: 'utils__showSuccess'
};

UtilsMixin = Object.assign(UtilsMixin, apiMethods);

export { UtilsMixin };