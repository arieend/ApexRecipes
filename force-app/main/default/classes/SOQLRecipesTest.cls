/*************************************************************************************************************
 * @name			  SOQLRecipesTest
 * @author			arieend <arieend@gmail.com>
 * @created			03 / 10 / 2020
 * @description Test Learn new technology, patterns, and best practices for solving
 *              practical problems with code.
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 			    	No.		Date			    Author					      Description
 * 			    	----	------------	--------------------	----------------------------------------------
 * @version		1.0		2020-10-03		arieend				      	Changes desription
 *
 **************************************************************************************************************/
@isTest
private class SOQLRecipesTest {
  private static Account createAccount(Boolean setCountry, String country) {
    Account account = genAccountWithOptions(setCountry, country);
    insert account;
    return account;
  }
  private static void createAccounts(
    Boolean setCountry,
    String country,
    Integer numberOfAccounts
  ) {
    insert genXnumberOfAccountWithOptions(
      setCountry,
      country,
      numberOfAccounts
    );
  }
  private static List<Account> genXnumberOfAccountWithOptions(
    Boolean setCountry,
    String country,
    Integer numberOfAccounts
  ) {
    List<Account> acctList = new List<Account>();
    for (Integer i = 0; i < numberOfAccounts; i++) {
      acctList.add(genAccountWithOptions(setCountry, country));
    }
    return acctList;
  }
  private static Account genAccountWithOptions(
    Boolean setCountry,
    String country
  ) {
    Account acct = new Account(
      Name = 'The Test Account of Awesomeness' + Crypto.getRandomInteger(),
      ShippingStreet = '123 Sessame St.',
      ShippingCity = 'Wehawkin'
    );
    if (setCountry) {
      acct.ShippingCountry = country;
    }
    return acct;
  }
  private static Contact genContactForAccount(ID acctID) {
    return new Contact(
      AccountID = acctID,
      LastName = 'Spectecular',
      FirstName = String.valueOf(Crypto.getRandomInteger())
    );
  }
  private static User createUser(Boolean ins, String profileName) {
    Profile standartProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = :profileName
    ];
    User contextuser = new User(
      Alias = 'standt',
      Email = 'arieend@apexrecipes.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = standartProfile.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'arieend@apexrecipes.com'
    );
    if (ins) {
      insert contextuser;
    }
    return contextuser;
  }

  @IsTest
  static void securityEnforcedTestDenies() {
    /*********************************************************************************************************
     * @name			  securityEnforcedTest
     * @author			arieend <arieend@gmail.com>
     * @created			03 / 10 / 2020
     * @description	1. Create user account
     *              2. Assign permission set tu user
     *              3. Run test with System.runAs with created user
     **********************************************************************************************************/

    User contextuser = SOQLRecipesTest.createUser(true, 'NO Accounts');
    Test.startTest();
    // RunAs the user
    System.runAs(contextuser) {
      createAccount(false, '');
      Boolean didCatchProperException = false;
      try {
        List<Account> testAccounts = SOQLRecipes.querySingleObject();
      } catch (QueryException queryException) {
        if (queryException.getMessage().contains('Insufficient permissions')) {
          didCatchProperException = true;
        }
      }
      System.assert(
        didCatchProperException,
        'Excpected a user with profile \'No Accounts\' to not be able to query Account'
      );
    }
    Test.stopTest();
  }
  @IsTest
  static void securityEnforcedTestGrantedByPermissionSet() {
    User contextuser = SOQLRecipesTest.createUser(true, 'NO Accounts');
    ID permissionSetId = [
      SELECT ID
      FROM PermissionSet
      WHERE Name = 'Proving_With_Security_Enforced_Works'
      LIMIT 1
    ]
    .Id;
    PermissionSetAssignment psa = new PermissionSetAssignment(
      PermissionSetId = permissionSetId,
      AssigneeId = contextuser.ID
    );
    insert psa;
    Test.startTest();
    System.runAs(contextuser) {
      createAccount(false, '');
      List<Account> testAccounts = SOQLRecipes.querySingleObject();
      System.assertEquals(
        1,
        testAccounts.size(),
        'Excpected to find 1 account'
      );
    }
    Test.stopTest();
  }
  @IsTest
  static void querySingleObjectTest() {
    createAccount(false, '');
    System.assertEquals(
      [SELECT id FROM Account].size(),
      1,
      'expected 1 record'
    );
    Test.startTest();
    List<Account> testAccounts = SOQLRecipes.querySingleObject();
    Test.stopTest();
    System.assertEquals(
      testAccounts.size(),
      1,
      'We found more then 1 having created exactly 1'
    );
    System.assert(testAccounts[0].Name.contains('Awesomeness'));
  }
  @IsTest
  static void queryMassiveNummberOfRecordsReturningCountTest() {
    // create test data
    List<Account> testAccounts = new List<Account>();
    for (Integer x = 0; x <= 1; x++) {
      for (Integer i = 0; i < 1500; i++) {
        testAccounts.add(genAccountWithOptions(false, ''));
      }
      insert testAccounts;
      testAccounts.clear();
    }

    System.assertEquals(
      [SELECT id FROM Account].size(),
      3000,
      'expeted to have created'
    );
    Test.startTest();
    Integer count = SOQLRecipes.QueryMassiveNummberOfRecordsReturningCount();
    Test.stopTest(); // force all async jobs to complete
    System.assertEquals(count, 3000, 'Expected found 3k records');
  }
  @IsTest
  static void getFilteredListTestNegative() {
    createAccount(false, '');
    System.assertEquals(
      [SELECT id FROM Account].size(),
      1,
      'expected 1 record'
    );

    Test.startTest();
    List<Account> testAccounts = SOQLRecipes.getFilteredList();
    Test.stopTest();
    System.assertEquals(
      testAccounts.size(),
      0,
      'we expected no record be found'
    );
  }
  @IsTest
  static void getFilteredListTestPositive() {
    createAccount(true, 'UK');
    System.assertEquals(
      [SELECT id FROM Account].size(),
      1,
      'expected 1 record'
    );
    Test.startTest();
    List<Account> testAccounts = SOQLRecipes.getFilteredList();
    Test.stopTest();
    System.assertEquals(
      testAccounts.size(),
      1,
      'we expected 1 record be found'
    );
  }
  @IsTest
  static void getComplexFilteredListTest() {
    // Prepare data
    Map<Account, Boolean> testCase = new Map<Account, Boolean>();
    testCase.put(genAccountWithOptions(true, 'US'), false);
    testCase.put(genAccountWithOptions(true, 'CA'), false);
    Account positiveCase1 = genAccountWithOptions(true, 'US');
    positiveCase1.ShippingState = 'Indiana';
    positiveCase1.Industry = 'Fast Food - made whole';
    Account positiveCase2 = genAccountWithOptions(true, 'US');
    positiveCase2.ShippingState = 'Indiana';
    positiveCase2.Industry = 'Slow Food - Made quickly';
    testCase.put(positiveCase1, true);
    testCase.put(positiveCase2, true);

    insert (new List<Account>(testCase.keySet())).deepClone();

    System.assertEquals(
      [SELECT id FROM Account].size(),
      4,
      'expected 4 record'
    );
    // Test
    Test.startTest();
    List<Account> acctList = SOQLRecipes.getComplexFilteredList();
    Test.stopTest();
    // Assertions
    System.assertEquals(acctList.size(), 2, 'we expected 2 record be found');
    Set<String> accNames = new Set<String>();
    for (Account acctItem : acctList) {
      accNames.add(acctItem.Name);
    }
    Integer positiveCnt = 0;
    Integer negativeCnt = 0;
    for (Account accKey : testCase.keySet()) {
      if (testCase.get(accKey) == true) {
        positiveCnt++;
        System.assert(accNames.contains(accKey.Name), 'Found postive result');
      } else {
        negativeCnt++;
        System.assert(!accNames.contains(accKey.Name), 'Found negative result');
      }
    }
    System.assertEquals(positiveCnt, 2, 'Expected 2 positive results');
    System.assertEquals(negativeCnt, 2, 'Expected 2 negative results');
  }
  @IsTest
  static void getSpecificNumberOfResultsTestMore() {
    Integer numOfRecords = 15;
    Integer expectedNumOfRecords = 10;
    createAccounts(true, 'US', numOfRecords);
    System.assertEquals(
      [SELECT id FROM Account].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );

    Test.startTest();
    List<Account> accounts = SOQLRecipes.getSpecificNumberOfResults();
    Test.stopTest();
    System.assertEquals(
      expectedNumOfRecords,
      accounts.size(),
      'expected ' +
      expectedNumOfRecords +
      ' records after inserting ' +
      numOfRecords
    );
  }
  @IsTest
  static void getSpecificNumberOfResultsTestLess() {
    Integer numOfRecords = 3;
    Integer expectedNumOfRecords = 3;
    createAccounts(true, 'US', numOfRecords);
    System.assertEquals(
      [SELECT id FROM Account].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );

    Test.startTest();
    List<Account> accounts = SOQLRecipes.getSpecificNumberOfResults();
    Test.stopTest();
    System.assertEquals(
      expectedNumOfRecords,
      accounts.size(),
      'expected ' +
      expectedNumOfRecords +
      ' records after inserting ' +
      numOfRecords
    );
  }
  @IsTest
  static void getFirstXResultTest() {
    Integer numOfRecords = 8;
    Integer expectedNumOfRecords = 3;
    createAccounts(true, 'US', numOfRecords);
    System.assertEquals(
      [SELECT id FROM Account].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );

    Test.startTest();
    List<Account> accounts = SOQLRecipes.getFirstXResult(expectedNumOfRecords);
    Test.stopTest();
    System.assertEquals(
      expectedNumOfRecords,
      accounts.size(),
      'expected ' +
      expectedNumOfRecords +
      ' records after inserting ' +
      numOfRecords
    );
  }
  @IsTest
  static void getAccountsInStateTest() {
    Integer numOfRecords = 3;
    Integer expectedNumOfRecords = 3;
    List<Account> toInsert = genXnumberOfAccountWithOptions(true, 'US', 3);
    for (Account acct : toInsert) {
      acct.ShippingState = 'TX';
    }
    insert toInsert;

    System.assertEquals(
      [SELECT id FROM Account].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );
    TeSt.startTest();
    List<Account> accounts = SOQLRecipes.getAccountsInState('TX');
    List<Account> accountsWA = SOQLRecipes.getAccountsInState('WA');
    Test.stopTest();
    System.assertEquals(
      expectedNumOfRecords,
      accounts.size(),
      'expected ' +
      expectedNumOfRecords +
      ' records after inserting ' +
      numOfRecords +
      ' for TX state'
    );
    System.assertNotEquals(
      expectedNumOfRecords,
      accountsWA.size(),
      'expected 0 records after inserting ' +
      numOfRecords +
      ' for TX state'
    );
  }
  @IsTest
  static void getSecond10AccountTestMore() {
    Integer numOfRecords = 25;
    Integer expectedNumOfRecords = 10;
    createAccounts(true, 'US', numOfRecords);
    System.assertEquals(
      [SELECT id FROM Account].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );
    Test.startTest();
    List<Account> accounts = SOQLRecipes.getSecond10Account();
    Test.stopTest();
    System.assertEquals(
      expectedNumOfRecords,
      accounts.size(),
      'expected ' +
      expectedNumOfRecords +
      ' records after inserting ' +
      numOfRecords
    );
  }
  @IsTest
  static void getSecond10AccountTestLess() {
    Integer numOfRecords = 15;
    Integer expectedNumOfRecords = 5;
    createAccounts(true, 'US', numOfRecords);
    System.assertEquals(
      [SELECT id FROM Account].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );
    Test.startTest();
    List<Account> accounts = SOQLRecipes.getSecond10Account();
    Test.stopTest();
    System.assertEquals(
      expectedNumOfRecords,
      accounts.size(),
      'expected ' +
      expectedNumOfRecords +
      ' records after inserting ' +
      numOfRecords
    );
  }
  @IsTest
  static void getContactsAndAccountsTest() {
    Integer numOfRecords = 3;
    Integer expectedNumOfRecords = 3;
    List<Account> accounts = genXnumberOfAccountWithOptions(
      true,
      'US',
      numOfRecords
    );
    insert accounts;
    List<Contact> contacts = new List<Contact>();
    for (Account account : accounts) {
      for (Integer i = 0; i < 5; i++) {
        contacts.add(genContactForAccount(account.Id));
      }
    }
    insert contacts;
    System.assertEquals(
      [SELECT id FROM Account].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );
    System.assertEquals(
      [SELECT id FROM Contact].size(),
      (numOfRecords * 5),
      'expected ' +
      (numOfRecords * 5) +
      ' record'
    );
    Test.startTest();
    List<Account> results = SOQLRecipes.getContactsAndAccounts();
    Test.stopTest();
    System.assertEquals(
      expectedNumOfRecords,
      results.size(),
      'expected ' +
      expectedNumOfRecords +
      ' records after inserting ' +
      numOfRecords
    );
    Map<ID, Account> accountMap = new Map<ID, Account>(accounts);
    for (Account acct : results) {
      List<Contact> cts = acct.getSObjects('Contacts');
      // System.assertEquals(1, cts.size(), 'Expected to find a single contact');
      // System.assertNotEquals( null, cts[0].Id, 'Expected contact Id not to be null')
      System.assertEquals(5, cts.size(), 'Expected to find a single contact');
      for (Contact ct : cts) {
        System.assertNotEquals(null, ct.Id, 'Expected the Id not to be null');
        System.assert(
          accountMap.keySet().contains(ct.AccountId),
          'Expected that accountIds are known to Contatc'
        );
      }
    }
  }
  @IsTest
  static void getParentDetailsForChildTest() {
    Integer numOfRecords = 1;
    Integer expectedNumOfRecords = 1;
    List<Account> accounts = genXnumberOfAccountWithOptions(
      true,
      'US',
      numOfRecords
    );
    for (Account acct : accounts) {
      acct.ShippingState = 'Kansas';
    }
    insert accounts;
    List<Contact> contacts = new List<Contact>();
    for (Account account : accounts) {
      contacts.add(genContactForAccount(account.Id));
    }
    insert contacts;
    System.assertEquals(
      [SELECT id FROM Account].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );
    System.assertEquals(
      [SELECT id FROM Contact].size(),
      numOfRecords,
      'expected ' +
      numOfRecords +
      ' record'
    );
    Test.startTest();
    List<Contact> cts = SOQLRecipes.getParentDetailsForChild();
    Test.stopTest();
    System.assertEquals(1, cts.size(), 'Expected to find a single contact');
    System.assertNotEquals(
      null,
      cts[0].account.name,
      'Expected account name to be populated'
    );
  }
  @IsTest
  static void getDetailsFromBothParentsTest() {
    Junction_Demo_1__c jd1 = new Junction_Demo_1__c();
    Junction_Demo_2__c jd2 = new Junction_Demo_2__c();
    insert jd1;
    insert jd2;

    Junction__c junction = new Junction__c(
      Parent1__c = jd1.id,
      Parent2__c = jd2.id
    );
    insert junction;

    Test.startTest();
    List<Junction__c> results = SOQLRecipes.getDetailsFromBothParents();
    Test.stopTest();
    System.assertNotEquals(
      null,
      results[0].parent1__r.name,
      'Expected parent1\'s name not to be null'
    );
    System.assertNotEquals(
      null,
      results[0].parent2__r.name,
      'Expected parent2\'s name not to be null'
    );
  }
  @IsTest
  static void getSumOfOpportunitiesTest() {
    Account account = createAccount(true, 'It');
    List<Opportunity> opps = new List<Opportunity>();
    Integer length = 5;
    for (Integer i = 0; i < length; i++) {
      opps.add(
        new Opportunity(
          Name = 'Epic Opportunity' + i,
          StageName = 'Qualification',
          accountId = account.id,
          amount = 1000.00,
          CloseDate = Date.today().addDays(14)
        )
      );
    }
    insert opps;
    Test.startTest();
    Double total = SOQLRecipes.getSumOfOpportunities(account.Id);
    Test.stopTest();
    System.assertEquals(
      5000.00,
      total,
      'Expected amount ofOpportunities is 5000'
    );
  }
}
