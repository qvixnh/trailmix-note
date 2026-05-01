@isTest
global class AnimalLocatorMockError implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"error":"Not Found"}');
        res.setStatusCode(404);
        return res;
    }
}
