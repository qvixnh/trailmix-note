trigger AccountsTrigger on Account (
    before insert, before update,
    after insert, after update,
    before delete, after delete, after undelete
) {
    fflib_SObjectDomain.triggerHandler(Accounts.class);
}
