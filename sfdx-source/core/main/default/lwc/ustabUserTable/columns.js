/*
 * Columns for lightning-table.
 *
 * Created by Yurii Heorhiiev on 08.08.2022.
 * <savthe217@gmail.com>
 */

import labels from "./labels";

export default [
    {
        label: labels.labelOwner,
        fieldName: 'ownerName',
        type: 'ownerName',
        typeAttributes: {
            smallPhotoUrl: {fieldName: 'smallPhotoUrl'}
        },
        sortable: true,
        fixedWidth: 300
    },
    {
        label: labels.labelTotalLeads,
        fieldName: 'totalLeads',
        type: 'number',
        sortable: true,
        fixedWidth: 140
    },
    {
        label: labels.labelTotalOpportunities,
        fieldName: 'totalOpportunities',
        type: 'number',
        sortable: true,
        fixedWidth: 140
    },
    {
        label: labels.labelConversionRate,
        fieldName: 'conversionRate',
        type: 'percent',
        typeAttributes: {
            step: '0.01',
            minimumFractionDigits: '2',
            maximumFractionDigits: '2'
        },
        sortable: true,
        fixedWidth: 180
    },
    {
        label: labels.labelLatestOpportunityDate,
        fieldName: 'lastOpportunityDate',
        type: 'date',
        cellAttributes: {alignment: 'right'},
        sortable: true,
        fixedWidth: 240
    },
    {
        label: labels.labelTotalOpportunitiesValue,
        fieldName: 'totalAmount',
        type: 'currency',
        sortable: true,
        fixedWidth: 180
    },
];