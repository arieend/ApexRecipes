@isTest
private class SOQLRecipesTest {
  private static void createAccount(Boolean setCountry, String country) {
    insert genAccountWithOptions(setCountry, country);
  }
  private static void createAccounts(
    Boolean setCountry,
    String country,
    Integer totalCnt
  ) {
    List<Account> acctList = new List<Account>();
    for (Integer i = 0; i < totalCnt; i++) {
      acctList.add(genAccountWithOptions(setCountry, country));
    }
    if (acctList.size() > 0) {
      insert acctList;
    }
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
  @IsTest
  static void testSipmleQuerySingleObject() {
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
  static void testCountOfLargeDataVolums() {
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
  static void testQueryWithFilterNegativeNoMatch() {
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
  static void testQueryWithFilterPositive() {
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
  static void testComplexFilterOmnibus() {
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
  static void testLimitClauseMoreThen10Accounts() {
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
      'expected ' +  expectedNumOfRecords + ' records after inserting ' + numOfRecords
    );
  }
  @IsTest
  static void testLimitClauseLessThen10Accounts() {
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
}
