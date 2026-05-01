@isTest
private class ParkLocatorTest {

    @isTest
    static void testCountry() {
        // Set mock
        Test.setMock(WebServiceMock.class, new ParkServiceMock());

        // Call method
        List<String> result = ParkLocator.country('United States');

        // Assertions
        System.assertNotEquals(null, result);
        System.assertEquals(2, result.size());
        System.assertEquals('Yellowstone', result[0]);
        System.assertEquals('Yosemite', result[1]);
    }
}
