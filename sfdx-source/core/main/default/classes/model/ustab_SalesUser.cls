/*
 * Object representation of Sales User.
 *
 * Created by Yurii Heorhiiev on 01.08.2022.
 * <savthe217@gmail.com>
 */

public with sharing class ustab_SalesUser implements Comparable {
    public static String sortBy;
    public static String sortOrder;
    @AuraEnabled
    public Id ownerId;
    @AuraEnabled
    public String ownerName;
    @AuraEnabled
    public Integer totalLeads;
    @AuraEnabled
    public Integer totalOpportunities;
    @AuraEnabled
    public Double conversionRate;
    @AuraEnabled
    public Datetime lastOpportunityDate;
    @AuraEnabled
    public Decimal totalAmount;
    @AuraEnabled
    public String smallPhotoUrl;

    public Integer compareTo(Object compared) {
        ustab_SalesUser comparedUser = (ustab_SalesUser) compared;
        Integer multiply = 1;

        if (sortOrder.equals('desc')) {
            multiply = -1;
        }

        if (sortBy.equals(ustab_SalesUserService.ORDER_USER_FULL_NAME)) {
            return this.ownerName.compareTo(comparedUser.ownerName) * multiply;
        } else if (sortBy.equals(ustab_SalesUserService.ORDER_CONVERSION_RATE)) {
            Double result = this.conversionRate - comparedUser.conversionRate;
            Integer comparison = 0;

            if (result < 0) {
                comparison = -1;
            } else if (result > 0) {
                comparison = 1;
            }

            return comparison * multiply;
        }

        return 0;
    }
}