public with sharing class Accounts extends fflib_SObjectDomain {

    // Constructor
    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }

    // Factory
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts((List<Account>) sObjectList);
        }
    }

    // APPLY DEFAULTS
    public override void onApplyDefaults() {
        for (Account acc : (List<Account>) Records) {
            if (acc.Description == null) {
                acc.Description = 'Domain classes rock!';
            }
        }
    }

    // BEFORE UPDATE
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        for (Account acc : (List<Account>) Records) {
            String target = 'Domain classes rock!';
            String current = acc.Description;

            if (current != null) {
                Integer distance = target.getLevenshteinDistance(current);
                acc.AnnualRevenue = distance;
            }
        }
    }
}
