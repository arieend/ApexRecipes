@isTest
private class SOQLRecipesTest {
  private static void createAccount(Boolean setCountry, String country) {
    insert genAccountWithOptions(setCountry, country);
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
}
