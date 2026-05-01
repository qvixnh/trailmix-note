@isTest
public class OrderEventTriggerTest {
    @isTest
    static void testTrigger() {
        Order_Event__e evt = new Order_Event__e(
            Order_Number__c = '105',
            Has_Shipped__c = true
        );

        Test.startTest();
        Database.SaveResult sr = EventBus.publish(evt);
        Test.stopTest();

        System.assertEquals(true, sr.isSuccess());

        List<Task> tasks = [SELECT Id, Subject FROM Task];
        System.assertEquals(1, tasks.size());
        System.assert(tasks[0].Subject.contains('105'));
    }
}
