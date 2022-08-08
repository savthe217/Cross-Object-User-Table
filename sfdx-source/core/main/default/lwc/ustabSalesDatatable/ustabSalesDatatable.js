/*
 * Custom lightning datatable for sales stats.
 *
 * Created by Yurii Heorhiiev on 08.08.2022.
 * <savthe217@gmail.com>
 */

import LightningDatatable from 'lightning/datatable';
import ownerNameTemplate from './ownerName.html';

export default class UstabSalesDatatable extends LightningDatatable {
    static customTypes = {
        ownerName: {
            template: ownerNameTemplate,
            standardCellLayout: true,
            typeAttributes: ['smallPhotoUrl']
        }
    };
}
