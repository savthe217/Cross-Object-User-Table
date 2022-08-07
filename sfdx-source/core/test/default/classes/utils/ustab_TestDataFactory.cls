/*
 * Class for generating data for tests.
 *
 * Created by Yurii Heorhiiev on 30.07.2022.
 * <savthe217@gmail.com>
 */

@IsTest
public class ustab_TestDataFactory {
    /**
     * @return created user with PermissionSet assigned
     */
    public static User setupAdminUser() {
        String uniqueness = Datetime.now() + ':' + Math.random();
        try {
            throw new NullPointerException();
        } catch (Exception e) {
            uniqueness += e.getStackTraceString(); //includes the top level test method name without having to pass it
        }

        Profile userProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];
        UserRole testRole = new UserRole(Name = 'Test role:' + uniqueness.hashCode());
        insert testRole;
        User testUser = new User(
            Username = UserInfo.getUserId() +
                '.' +
                uniqueness.hashCode() +
                '@' +
                UserInfo.getOrganizationId() +
                '.sfdcOrg',
            Alias = 'testExec',
            Email = 'test@admin.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'GMT',
            UserRoleId = testRole.Id
        );
        insert testUser;

        return testUser;
    }

    /**
     * @param count number of leads
     * @param ownerId leads owner
     */
    public static void createLeads(Integer count, Id ownerId) {
        String uniqueness = Datetime.now().second() + ':' + Math.random();

        List<Lead> leads = new List<Lead>();

        for (Integer i = 1; i <= count; i++) {
            Lead newLead = new Lead(FirstName = 'Lead' + uniqueness + i, LastName = 'Test', Company = 'Self Commerce');

            if (ownerId != null) {
                newLead.OwnerId = ownerId;
            }

            leads.add(newLead);
        }

        insert leads;
    }

    /**
     * @param count number of leads
     */
    public static void createLeads(Integer count) {
        createLeads(count, null);
    }

    /**
     * @param count number of opportunities
     * @param singleAmount single opportunity amount
     * @param ownerId opportunities owner
     */
    public static void createOpportunities(Integer count, Decimal singleAmount, Id ownerId) {
        String uniqueness = Datetime.now().second() + ':' + Math.random();

        List<Opportunity> opportunities = new List<Opportunity>();

        for (Integer i = 1; i <= count; i++) {
            Opportunity newOpportunity = new Opportunity(Name = 'Opportunity' + uniqueness + i, StageName = 'Closed Won',
                CloseDate = Date.today(), Amount = singleAmount);

            if (ownerId != null) {
                newOpportunity.OwnerId = ownerId;
            }

            opportunities.add(newOpportunity);
        }

        insert opportunities;
    }

    /**
     * @param count number of opportunities
     * @param singleAmount single opportunity amount
     */
    public static void createOpportunities(Integer count, Decimal singleAmount) {
        createOpportunities(count, singleAmount, null);
    }
}