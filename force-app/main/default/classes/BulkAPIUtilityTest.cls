/**
 * Author: PavanVarma Pinnamaraju
 * Created Date: 09-04-2024
 * Description: Test class for BulkAPIUtility class.
 *              This class tests the functionality of the BulkAPIUtility class.
 **/
@IsTest 
private with sharing class BulkAPIUtilityTest {
    
    // Define constants for test data
    public static final String TITLE = 'Data csv.csv';
    
    
     /**
     * Author: PavanVarma Pinnamaraju
     * Created Date: 09-04-2024
     * Description: Test data setup method.
     *              This method creates test data required for the test methods.
     **/
    @testSetup
    static void setupTestData() {
        User standardUser = TestFactoryClass.createUser('Standard User');
        
        User stdUser = TestFactoryClass.getUser('Standard User');
        
        System.runAs(stdUser) {
             // Create Content Version
            ContentVersion cv = TestFactoryClass.createContentVersion('Data csv.csv');
        }
    }
    
    /**
     * Author: Author: PavanVarma Pinnamaraju
     * Created Date: 09-04-2024
     * Description: Test method to verify the coverage of importBulkdata.
     **/
    
    @isTest
    static void testBulkAPI() {
        User stdUser = TestFactoryClass.getUser('Standard User');
        
        System.runAs(stdUser) {
            // Query Creataed Content Version record
            ContentVersion dataContent = [SELECT Id, ContentDocumentId, title, VersionData FROM ContentVersion WHERE title =: TITLE];
            
            BulkAPIUtility.BulkDataWrapper wrap = new BulkAPIUtility.BulkDataWrapper();
            wrap.fileIdList = new List<Id>{dataContent.ContentDocumentId};
            wrap.objectName = 'Contact';
            wrap.operation = 'Upsert';
            List<BulkAPIUtility.BulkDataWrapper> wrapList = new List<BulkAPIUtility.BulkDataWrapper>{wrap};
                
            // Start test
            Test.startTest();
            
            // Mocking HTTP response
            Test.setMock(HttpCalloutMock.class, new BulkAPIMock()); 
            BulkAPIUtility.contentValue = 'Start_Of_Session_Id'+ UserInfo.getSessionId() +'End_Of_Session_Id';
            
            String jsonData = '[{"fileIdList":["' + dataContent.ContentDocumentId + '"],"objectName":"SQX_Part__c","operation":"upsert"}]';
            
            // Call the method to test
            List<BulkAPIUtility.ResponseWrapper> resp = BulkAPIUtility.importBulkdata(wrapList, jsonData);
            
            // End test
            Test.stopTest();
            system.assertEquals('Data processing Start 750B0000009aLc9', resp[0].response);
        }

    }
    
        /**
     * Author: Author: PavanVarma Pinnamaraju
     * Created Date: 09-04-2024
     * Description: Test method to verify the coverage of importBulkdata catch block.
     **/
    
    @isTest
    static void testBulkAPICatch() {
        User stdUser = TestFactoryClass.getUser('Standard User');
        
        System.runAs(stdUser) {
            // Query Creataed Content Version record
            ContentVersion dataContent = [SELECT Id, ContentDocumentId, title, VersionData FROM ContentVersion WHERE title =: TITLE];
            
            BulkAPIUtility.BulkDataWrapper wrap = new BulkAPIUtility.BulkDataWrapper();
            wrap.fileIdList = new List<Id>{dataContent.ContentDocumentId};
            wrap.objectName = 'Contact';
            wrap.operation = 'Upsert';
            List<BulkAPIUtility.BulkDataWrapper> wrapList = new List<BulkAPIUtility.BulkDataWrapper>{wrap};
                
            // Start test
            Test.startTest();
            
            // Mocking HTTP response
            Test.setMock(HttpCalloutMock.class, new BulkAPIMock()); 
            BulkAPIUtility.contentValue = ''; 
            
            String jsonData = '[{"fileIdList":["' + dataContent.ContentDocumentId + '"],"objectName":"SQX_Part__c","operation":"upsert"}]';
            
            // Call the method to test
            List<BulkAPIUtility.ResponseWrapper> resp = BulkAPIUtility.importBulkdata(wrapList, jsonData);
            
            // End test
            Test.stopTest();
            system.assertEquals('Starting position out of bounds: 18', resp[0].response);
        }

    }

}