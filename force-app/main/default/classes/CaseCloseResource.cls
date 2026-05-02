@RestResource(urlMapping='/case/*/close')
global with sharing class CaseCloseResource {

    @HttpPost
    global static void closeCase(String reason) {

        RestRequest req = RestContext.request;

        // Parse Id from URL: /case/{Id}/close
        String[] parts = req.requestURI.split('/');
        Id caseId = parts[2];

        // Call service
        CaseService.closeCases(
            new Set<Id>{ caseId },
            reason
        );
    }
}
