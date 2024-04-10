/**
 * Author: PavanVarma Pinnamaraju
 * Created Date: 20-03-2024
 * Description: Test factory class for creating test data.
 *              This class provides methods to create test records for Accounts and SQX_Part__c objects.
 **/
@IsTest
public class TestFactoryClass {
    // Map to store profile name and associated permission sets
    private static Map<String, List<String>> profilePermissionSetsMap = new Map<String, List<String>>{
        'Standard User' => new List<String>{'CQ_Parts_PS'}
    };
        
    /**
     * Author: PavanVarma Pinnamaraju
     * Created Date: 20-03-2024
     * Description: Method to create a test User record.
     *              This method creates a User record with the specified profile name and inserts it into the database.
     *              It also assigns permission sets based on the profile.
     *              It returns the created User record.
     **/    
    public static user createUser(String profileName){
        String randomNumber = string.valueOf(system.currentTimeMillis());   
        List<Profile> profiles = new List<Profile>();
        profiles = [SELECT ID FROM Profile WHERE Name =: profileName];
        System.assert(!profiles.isEmpty(), 'Profile should be be empty '+profiles);
        User userRecord = new User();
        userRecord.Username = 'cqtest'+profileName.deleteWhitespace()+'@test.com';
        userRecord.Email = 'a' + randomNumber + '@test' + randomNumber + '.com';
        userRecord.FirstName =  'abc' + randomNumber;
        userRecord.LastName = randomNumber;
        userRecord.CommunityNickname =  randomNumber;
        userRecord.ProfileId = profiles[0].id;
        userRecord.Alias =  randomNumber.mid(4,6);
        userRecord.EmailEncodingKey = 'UTF-8';
        userRecord.LanguageLocaleKey = 'en_US';
        userRecord.LocaleSidKey = 'en_US';
        userRecord.TimeZoneSidKey = 'America/Los_Angeles';
        userRecord.IsActive=true;
        insert userRecord;

        if(profilePermissionSetsMap.containsKey(profileName)){
            List<PermissionSet> permissionSets = [SELECT ID FROM PermissionSet WHERE Name IN: profilePermissionSetsMap.get(profileName)];
            List<PermissionSetAssignment> lstPSA = new list<PermissionSetAssignment>();
            
            for (permissionSet ps:  permissionSets){
                PermissionSetAssignment  psa =   new PermissionSetAssignment(AssigneeId=userRecord.Id, PermissionSetId=ps.Id);
                lstPSA.add(psa);
            }
            
            insert lstPSA;
        }

        return userRecord;
    }

    /**
     * Author: PavanVarma Pinnamaraju
     * Created Date: 20-03-2024
     * Description: Method to retrieve a test User record based on profile name.
     *              This method queries for a User record with the specified profile name and returns it.
     **/
    public static User getUser(String profileName){
        User usr = null;
        string usrName = 'cqtest'+profileName.deleteWhitespace()+'@test.com';
        List<User> usrs = [SELECT id,Name FROM user WHERE username LIKE: usrName LIMIT 1];
        System.assert(!usrs.isEmpty(), 'No User found with given '+profileName+' profile name');
        usr = usrs[0];
        return usr;
    }
    
    /**
     * Author: PavanVarma Pinnamaraju
     * Created Date: 20-03-2024
     * Description: Method to create a test Account record.
     *              This method creates an Account record with the specified name and inserts it into the database.
     *              It returns the created Account record.
     **/
    public static Account createAccount(String accName){
        // Create Account record
        Account acc = new Account(
            Name = accName
        );
        // Insert Account record
        insert acc;
        // Return the created Account record
        return acc;
    }
    
    /**
     * Author: PavanVarma Pinnamaraju
     * Created Date: 20-03-2024
     * Description: Method to create a test SQX_Part__c record.
     *              This method creates an SQX_Part__c record with the specified name and part number, and inserts it into the database.
     *              It returns the created SQX_Part__c record.
     **/
    public static SQX_Part__c createPart(String partName, String partNumber){
        // Create SQX_Part__c record
        SQX_Part__c part = new SQX_Part__c(
            Name = partName,
            Part_Number__c = partNumber
        );
        // Insert SQX_Part__c record
        insert part;
        // Return the created SQX_Part__c record
        return part;
    }
     /**
     * Author: PavanVarma Pinnamaraju
     * Created Date: 09-04-2024
     * Description: Method to create a test Content version record.
     *              This method creates an Content version with the specified title and inserts it into the database.
     *              It returns the created content version record.
     **/
    public static ContentVersion createContentVersion(String title){
        // Create Content Version
        String csv = 'FirstName,LastName\nnewstechnologyystuff,demo';
        ContentVersion cv = new ContentVersion();
        cv.title = title;      
        cv.PathOnClient ='Data csv.csv';           
        cv.VersionData =Blob.valueOf(csv);         

        // Insert content version 
        insert cv;
        // Return the created Content version
        return cv;
    }
}