/*
 * Test class for SalesUserService.
 *
 * Created by Yurii Heorhiiev on 30.07.2022.
 * <savthe217@gmail.com>
 */

@IsTest
private class ustab_SalesUserServiceTest {
    @TestSetup
    static void setup() {
        Test.startTest();

        User salesUser1 = ustab_TestDataFactory.setupAdminUser();

        System.runAs(salesUser1) {
            ustab_TestDataFactory.createLeads(100);
            ustab_TestDataFactory.createOpportunities(10, 10);
        }

        User salesUser2 = ustab_TestDataFactory.setupAdminUser();

        System.runAs(salesUser2) {
            ustab_TestDataFactory.createLeads(30);
            ustab_TestDataFactory.createOpportunities(15, 10);
        }

        Test.stopTest();
    }

    @IsTest
    static void getSalesUsersAll() {
        Test.startTest();

        Date startDate = Datetime.now().addDays(-1).date();
        Date endDate = Datetime.now().addMonths(2).date();
        List<ustab_SalesUser> salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_USER_FULL_NAME, 'asc');

        System.assertEquals(2, salesUsers.size());

        ustab_SalesUser salesStats1 = salesUsers.get(0);
        ustab_SalesUser salesStats2 = salesUsers.get(1);

        System.assertEquals(100, salesStats1.totalAmount);
        System.assertEquals(150, salesStats2.totalAmount);
        System.assertEquals(100, salesStats1.totalLeads);
        System.assertEquals(15, salesStats2.totalOpportunities);
        System.assertEquals(0.1, salesStats1.conversionRate);

        Test.stopTest();
    }

    @IsTest
    static void getSalesUsersFilter() {
        Test.startTest();

        Date startDate = Datetime.now().addMonths(2).date();
        Date endDate = Datetime.now().addMonths(3).date();
        List<ustab_SalesUser> salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_USER_FULL_NAME, 'asc');

        System.assertEquals(0, salesUsers.size());

        Test.stopTest();
    }

    @IsTest
    static void getSalesUsersSortName() {
        Test.startTest();

        Date startDate = Datetime.now().addDays(-1).date();
        Date endDate = Datetime.now().addMonths(2).date();
        List<ustab_SalesUser> salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_USER_FULL_NAME, 'asc');

        ustab_SalesUser salesStats1 = salesUsers.get(0);
        ustab_SalesUser salesStats2 = salesUsers.get(1);
        System.assertEquals(100, salesStats1.totalAmount);
        System.assertEquals(150, salesStats2.totalAmount);

        salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_USER_FULL_NAME, 'desc');
        salesStats1 = salesUsers.get(0);
        salesStats2 = salesUsers.get(1);
        System.assertEquals(150, salesStats1.totalAmount);
        System.assertEquals(100, salesStats2.totalAmount);

        Test.stopTest();
    }

    @IsTest
    static void getSalesUsersSortLeads() {
        Test.startTest();

        Date startDate = Datetime.now().addDays(-1).date();
        Date endDate = Datetime.now().addMonths(2).date();
        List<ustab_SalesUser> salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_TOTAL_LEADS, 'asc');

        ustab_SalesUser salesStats1 = salesUsers.get(0);
        ustab_SalesUser salesStats2 = salesUsers.get(1);
        System.assertEquals(30, salesStats1.totalLeads);
        System.assertEquals(100, salesStats2.totalLeads);

        salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_TOTAL_LEADS, 'desc');

        salesStats1 = salesUsers.get(0);
        salesStats2 = salesUsers.get(1);
        System.assertEquals(100, salesStats1.totalLeads);
        System.assertEquals(30, salesStats2.totalLeads);

        Test.stopTest();
    }

    @IsTest
    static void getSalesUsersSortOpportunities() {
        Test.startTest();

        Date startDate = Datetime.now().addDays(-1).date();
        Date endDate = Datetime.now().addMonths(2).date();
        List<ustab_SalesUser> salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_TOTAL_OPPORTUNITIES, 'asc');

        ustab_SalesUser salesStats1 = salesUsers.get(0);
        ustab_SalesUser salesStats2 = salesUsers.get(1);
        System.assertEquals(10, salesStats1.totalOpportunities);
        System.assertEquals(15, salesStats2.totalOpportunities);

        salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_TOTAL_OPPORTUNITIES, 'desc');

        salesStats1 = salesUsers.get(0);
        salesStats2 = salesUsers.get(1);
        System.assertEquals(15, salesStats1.totalOpportunities);
        System.assertEquals(10, salesStats2.totalOpportunities);

        Test.stopTest();
    }

    @IsTest
    static void getSalesUsersSortAmount() {
        Test.startTest();

        Date startDate = Datetime.now().addDays(-1).date();
        Date endDate = Datetime.now().addMonths(2).date();
        List<ustab_SalesUser> salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_TOTAL_AMOUNT, 'asc');

        ustab_SalesUser salesStats1 = salesUsers.get(0);
        ustab_SalesUser salesStats2 = salesUsers.get(1);
        System.assertEquals(100, salesStats1.totalAmount);
        System.assertEquals(150, salesStats2.totalAmount);

        salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_TOTAL_AMOUNT, 'desc');

        salesStats1 = salesUsers.get(0);
        salesStats2 = salesUsers.get(1);
        System.assertEquals(150, salesStats1.totalAmount);
        System.assertEquals(100, salesStats2.totalAmount);

        Test.stopTest();
    }

    @IsTest
    static void getSalesUsersSortConversion() {
        Test.startTest();

        Date startDate = Datetime.now().addDays(-1).date();
        Date endDate = Datetime.now().addMonths(2).date();
        List<ustab_SalesUser> salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_CONVERSION_RATE, 'asc');

        ustab_SalesUser salesStats1 = salesUsers.get(0);
        ustab_SalesUser salesStats2 = salesUsers.get(1);
        System.assertEquals(0.1, salesStats1.conversionRate);
        System.assertEquals(0.5, salesStats2.conversionRate);

        salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_CONVERSION_RATE, 'desc');

        salesStats1 = salesUsers.get(0);
        salesStats2 = salesUsers.get(1);
        System.assertEquals(0.5, salesStats1.conversionRate);
        System.assertEquals(0.1, salesStats2.conversionRate);

        Test.stopTest();
    }

    @IsTest
    static void getSalesUsersSortLatestDate() {
        Test.startTest();

        Date startDate = Datetime.now().addDays(-1).date();
        Date endDate = Datetime.now().addMonths(2).date();
        List<ustab_SalesUser> salesUsers = ustab_SalesUserService.getSalesUsers(startDate, endDate,
            ustab_SalesUserService.ORDER_LATEST_OPPORTUNITY, 'asc');

        ustab_SalesUser salesStats1 = salesUsers.get(0);
        System.assertEquals(Date.today(), salesStats1.lastOpportunityDate.date());

        Test.stopTest();
    }
}