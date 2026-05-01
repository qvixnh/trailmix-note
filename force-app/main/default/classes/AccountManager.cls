@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {

    @HttpGet
    global static Account getAccount() {
        RestRequest req = RestContext.request;

        // Extract Account Id from URL
        String uri = req.requestURI;
        String accountId = uri.substring(
            uri.lastIndexOf('/Accounts/') + 10,
            uri.lastIndexOf('/contacts')
        );

        // Query Account + Contacts
        Account acc = [
            SELECT Id, Name,
                   (SELECT Id, Name FROM Contacts)
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        return acc;
    }
}
