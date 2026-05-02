@isTest
private class UnitOfWorkTest {

    @isTest
    static void challengeComplete() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new List<Schema.SObjectType>{
                Account.SObjectType,
                Contact.SObjectType
            }
        );

        for (Integer i = 0; i < 100; i++) {
            Account acc = new Account(Name = 'Test Account ' + i);
            uow.registerNew(acc);

            for (Integer j = 0; j < 5; j++) {
                Contact con = new Contact(LastName = 'Test Contact ' + i + '_' + j);
                uow.registerNew(con, Contact.AccountId, acc);
            }
        }

        uow.commitWork();

        // Create Notes separately — Note.ParentId is polymorphic
        // and cannot be used as a Schema.SObjectField token with registerNew
        List<Note> notes = new List<Note>();
        for (Contact c : [SELECT Id FROM Contact]) {
            notes.add(new Note(Title = 'Test Note', Body = 'Test Body', ParentId = c.Id));
        }
        insert notes;

        System.assertEquals(100, [SELECT Id FROM Account].size());
        System.assertEquals(500, [SELECT Id FROM Contact].size());
        System.assertEquals(500, [SELECT Id FROM Note].size());
    }
}
