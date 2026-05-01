@isTest
global class AnimalLocatorMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"animal":{"id":1,"name":"lion","eats":"meat","says":"roar"}}');
        res.setStatusCode(200);
        return res;
    }
}
