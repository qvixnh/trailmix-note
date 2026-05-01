@IsTest
private class AccountManagerTest {

    @IsTest
    static void testGetAccount() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con1 = new Contact(FirstName='A', LastName='One', AccountId=acc.Id);
        Contact con2 = new Contact(FirstName='B', LastName='Two', AccountId=acc.Id);
        insert new List<Contact>{con1, con2};

        // Mock REST request
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/Accounts/' + acc.Id + '/contacts';
        req.httpMethod = 'GET';

        RestContext.request = req;

        // Call method
        Account result = AccountManager.getAccount();

        // Assertions
        System.assertNotEquals(null, result);
        System.assertEquals(acc.Id, result.Id);
        System.assertEquals('Test Account', result.Name);
        System.assertEquals(2, result.Contacts.size());
    }
}
