@isTest
public class AnimalLocatorTest {
    @isTest
    static void testGetAnimalNameById() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());

        Test.startTest();
        String result = AnimalLocator.getAnimalNameById(1);
        Test.stopTest();

        System.assertEquals('lion', result);
    }

    @isTest
    static void testGetAnimalNameByIdError() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMockError());

        Test.startTest();
        String result = AnimalLocator.getAnimalNameById(0);
        Test.stopTest();

        System.assertEquals(null, result);
    }
}
