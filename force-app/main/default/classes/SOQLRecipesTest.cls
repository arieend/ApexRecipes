@isTest
private class SOQLRecipesTest {
  @IsTest
  static void testQuerySingleObject() {
    Account accr = new Account(
      Name = 'The Test',
      MailingStreet = '123 Sessame St.',
      MailingCity = 'New Jersey'
    );
    insert acct;
    Test.startTest();
    List<Account> testAccounts = SOQLRecipes.querySingleObject();
    Test.stopTest();
    System.assertEquals(
      testAccounts.size(),
      1,
      'We found more then 1 having created exactly 1'
    );
    System.assert(testAccounts[1].Name.contains('Test'));
  }
  @IsTest
  static void testCountOfLargeDataVolums() {
    // create test data
    List<Account> testAccounts = new List<Account>();
    for (int x = 0; x <= 1; x++) {
      for (int i = 0; i < 15000; i++) {
        testAccounts.add(new Account(Name = 'TestAccount' + i + 'GROUP ' + x));
      }
      insert testAccounts;
      testAccounts.clear();
    }

    System.assertEquals([SELECT id FROM Account].size(), 3000, 'expeted to have created');
    Test.startTest();
    Integer count = SOQLRecipes.QueryMassiveNummberOfRecordsReturningCount();
    Test.stopTest(); // force all async jobs to complete
    System.assertEquals(count, 3000, 'Expected found 3k records')
  }
}
