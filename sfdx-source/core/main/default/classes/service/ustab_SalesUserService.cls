/*
 * Service class for sales user related operations.
 *
 * Created by Yurii Heorhiiev on 30.07.2022.
 * <savthe217@gmail.com>
 */

public with sharing class ustab_SalesUserService {
    public static final String ORDER_TOTAL_AMOUNT = 'totalAmount';
    public static final String ORDER_TOTAL_OPPORTUNITIES = 'totalOpportunities';
    public static final String ORDER_LATEST_OPPORTUNITY = 'latestOpportunity';
    public static final String ORDER_TOTAL_LEADS = 'totalLeads';
    public static final String ORDER_USER_FULL_NAME = 'name';
    public static final String ORDER_CONVERSION_RATE = 'conversionRate';
    private static final List<String> opportunitiesOrderTypes = new List<String>{
        ORDER_TOTAL_AMOUNT, ORDER_LATEST_OPPORTUNITY, ORDER_TOTAL_OPPORTUNITIES
    };
    private static final List<String> leadsOrderTypes = new List<String>{
        ORDER_TOTAL_LEADS
    };

    /**
     * Retrieves statistics for sales users by a given date range.
     *
     * @param startDate date range start
     * @param endDate date range end
     * @param sortBy sort column
     * @param sortOrder sort order (ASC DESC)
     *
     * @return statistics for sales users
     */
    public static List<ustab_SalesUser> getSalesUsers(Date startDate, Date endDate, String sortBy, String sortOrder) {
        Map<Id, ustab_SalesUser> salesUsersByUserId = new Map<Id, ustab_SalesUser>();
        List<Id> salesUserOrder = new List<Id>();

        List<AggregateResult> results = queryOpportunitiesByOwner(startDate, endDate, sortBy, sortOrder);
        processOpportunitiesAggregateResults(results, sortBy, salesUserOrder, salesUsersByUserId);

        results = queryLeadsByOwner(startDate, endDate, sortBy, sortOrder);
        processLeadsAggregateResults(results, sortBy, salesUserOrder, salesUsersByUserId);

        List<ustab_SalesUser> salesUsers = constructSalesUserList(sortBy, salesUserOrder, salesUsersByUserId);

        ustab_SalesUser.sortBy = sortBy;
        ustab_SalesUser.sortOrder = sortOrder;
        if (sortBy.equals(ORDER_USER_FULL_NAME) || sortBy.equals(ORDER_CONVERSION_RATE)) {
            salesUsers.sort();
        }

        return salesUsers;
    }

    /**
     * @param sortBy sort field
     * @param salesUserOrder ordered list of user ids
     * @param salesUsersByUserId map of SalesUser by user Id
     *
     * @return list of SalesUser with complete fields
     */
    private static List<ustab_SalesUser> constructSalesUserList(String sortBy, List<Id> salesUserOrder,
        Map<Id, ustab_SalesUser> salesUsersByUserId) {
        List<ustab_SalesUser> salesUsers = new List<ustab_SalesUser>();
        Set<Id> userIds = salesUsersByUserId.keySet();

        if (userIds.isEmpty()) {
            return salesUsers;
        }

        Map<Id, User> usersByIds = new Map<Id, User>([
            SELECT Id, FirstName, LastName
            FROM User
            WHERE Id IN :userIds
            WITH SECURITY_ENFORCED
        ]);

        if (sortBy.equals(ORDER_USER_FULL_NAME) || sortBy.equals(ORDER_CONVERSION_RATE)) {
            salesUsers = salesUsersByUserId.values();
            for (ustab_SalesUser salesUser : salesUsers) {
                fillGenericFields(salesUser, usersByIds.get(salesUser.ownerId));
            }
        } else {
            for (Id userId : salesUserOrder) {
                if (!salesUsersByUserId.containsKey(userId)) {
                    continue;
                }

                ustab_SalesUser salesUser = salesUsersByUserId.get(userId);
                fillGenericFields(salesUser, usersByIds.get(userId));
                salesUsers.add(salesUser);
            }
        }

        return salesUsers;
    }

    /**
     * Computes and fills generic fields for sales user object.
     *
     * @param salesUser incomplete sales user
     * @param user salesforce user sobject
     */
    private static void fillGenericFields(ustab_SalesUser salesUser, User user) {
        if (user != null) {
            if (String.isNotBlank(user.FirstName)) {
                salesUser.ownerName = user.FirstName + ' ';
            } else {
                salesUser.ownerName = '';
            }

            salesUser.ownerName += user.LastName;
        }

        if (salesUser.totalLeads > 0) {
            salesUser.conversionRate = 100 * salesUser.totalOpportunities / salesUser.totalLeads;
        }
    }

    /**
     * Processes aggregate results for opportunities.
     *
     * @param results opportunities grouped by ownerId
     * @param sortBy sort field
     * @param salesUserOrder ordered list of user ids
     * @param salesUsersByUserId map of SalesUser by user Id
     */
    private static void processOpportunitiesAggregateResults(List<AggregateResult> results, String sortBy,
        List<Id> salesUserOrder, Map<Id, ustab_SalesUser> salesUsersByUserId) {
        Boolean isOpportunitiesSort = opportunitiesOrderTypes.contains(sortBy);

        for (AggregateResult result : results) {
            Id ownerId = String.valueOf(result.get('OwnerId'));
            ustab_SalesUser salesUser;

            if (salesUsersByUserId.containsKey(ownerId)) {
                salesUser = salesUsersByUserId.get(ownerId);
            } else {
                salesUser = new ustab_SalesUser();
            }

            salesUser.ownerId = ownerId;
            salesUser.totalOpportunities = Integer.valueOf(result.get('totalOpportunities'));
            salesUser.totalAmount = Decimal.valueOf(String.valueOf(result.get('totalAmount')));
            salesUser.lastOpportunityDate = Datetime.valueOf(result.get('latestDate'));

            if (isOpportunitiesSort) {
                salesUserOrder.add(ownerId);
            }

            salesUsersByUserId.put(ownerId, salesUser);
        }
    }

    /**
     * Processes aggregate results for leads.
     *
     * @param results opportunities grouped by ownerId
     * @param sortBy sort field
     * @param salesUserOrder ordered list of user ids
     * @param salesUsersByUserId map of SalesUser  by user Id
     */
    private static void processLeadsAggregateResults(List<AggregateResult> results, String sortBy,
        List<Id> salesUserOrder, Map<Id, ustab_SalesUser> salesUsersByUserId) {
        Boolean isLeadsSort = leadsOrderTypes.contains(sortBy);

        for (AggregateResult result : results) {
            Id ownerId = String.valueOf(result.get('OwnerId'));
            ustab_SalesUser salesUser;

            if (salesUsersByUserId.containsKey(ownerId)) {
                salesUser = salesUsersByUserId.get(ownerId);
            } else {
                salesUser = new ustab_SalesUser();
            }

            salesUser.ownerId = ownerId;
            salesUser.totalLeads = Integer.valueOf(result.get('totalLeads'));

            if (isLeadsSort) {
                salesUserOrder.add(ownerId);
            }

            salesUsersByUserId.put(ownerId, salesUser);
        }
    }

    /**
     * @param startDate date range start
     * @param endDate date range end
     * @param sortBy sort column
     * @param sortOrder sort order (ASC DESC)
     *
     * @return query results for opportunities grouped by owner
     */
    private static List<AggregateResult> queryOpportunitiesByOwner(Date startDate, Date endDate, String sortBy, String sortOrder) {
        String opportunitiesQuery =
            'SELECT OwnerId, COUNT(Id) totalOpportunities, SUM(Amount) totalAmount, MAX(CreatedDate) latestDate\n' +
                'FROM Opportunity\n' +
                'WHERE CloseDate >= :startDate AND CloseDate <= :endDate\n' +
                'WITH SECURITY_ENFORCED\n' +
                'GROUP BY OwnerId\n' +
                'ORDER BY ';

        if (sortBy.equals(ORDER_TOTAL_OPPORTUNITIES)) {
            opportunitiesQuery += 'COUNT(Id)';
        } else if (sortBy.equals(ORDER_LATEST_OPPORTUNITY)) {
            opportunitiesQuery += 'MAX(CreatedDate)';
        } else {
            opportunitiesQuery += 'SUM(Amount)';
        }

        opportunitiesQuery += ' ' + sortOrder;
        opportunitiesQuery += '\nLIMIT 20';

        return Database.query(opportunitiesQuery);
    }

    /**
     * @param startDate date range start
     * @param endDate date range end
     * @param sortBy sort column
     * @param sortOrder sort order (ASC DESC)
     *
     * @return query results for leads grouped by owner
     */
    private static List<AggregateResult> queryLeadsByOwner(Date startDate, Date endDate, String sortBy, String sortOrder) {
        String leadsQuery =
            'SELECT OwnerId, COUNT(Id) totalLeads\n' +
                'FROM Lead\n' +
                'WHERE CreatedDate >= :startDate AND CreatedDate <= :endDate\n' +
                'WITH SECURITY_ENFORCED\n' +
                'GROUP BY OwnerId\n' +
                'ORDER BY COUNT(Id) ' + sortOrder + '\n' +
                'LIMIT 20';

        return Database.query(leadsQuery);
    }
}