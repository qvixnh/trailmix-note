@isTest
global class ParkServiceMock implements WebServiceMock {

    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {

        ParkService.byCountryResponse res = new ParkService.byCountryResponse();
        res.return_x = new String[]{ 'Yellowstone', 'Yosemite' };
        response.put('response_x', res);
    }
}
