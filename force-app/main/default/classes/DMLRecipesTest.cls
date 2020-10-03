@isTest
private class DMLRecipesTest {
  @IsTest
  static void insertTheObjectKeywordTestPositive() {
    String name = 'Mambledore';
    Test.startTest();
    DMLRecipes.insertTheObjectKeyword(name);
    Test.stopTest();
    List<Account> accounts = [SELECT ID FROM Account WHERE Name = :name];
    System.assertEquals(1, accounts.size(), 'Expected 1 account');
  }
  @IsTest
  static void insertTheObjectKeywordTestNegative() {
    Test.startTest();
    Boolean didCatchProperException = false;
    try {
      DMLRecipes.insertTheObjectKeyword('');
    } catch (DMLRecipes.CustomDMLException customException) {
      if (customException.getMessage().contains('Failed to insert account')) {
        didCatchProperException = true;
      }
    }
    Test.stopTest();
    System.assert(didCatchProperException, 'Excpected exception to be thrown');
  }
  @IsTest
  static void insertTheObjectDatabaseMethodTestNegative() {
    Test.startTest();
    Boolean didCatchProperException = false;
    try {
      DMLRecipes.insertTheObjectDatabaseMethod('Mambledore', true);
    } catch (DMLRecipes.CustomDMLException customException) {
      if (
        customException.getMessage().contains('Failed with database method')
      ) {
        didCatchProperException = true;
      }
    }
    Test.stopTest();
    System.assert(didCatchProperException, 'Excpected exception to be thrown');
  }
  @IsTest
  static void insertTheObjectDatabaseMethodTestPositive() {
    String name = 'Mambledore';
    Test.startTest();
    DMLRecipes.insertTheObjectDatabaseMethod('Mambledore', false);
    Test.stopTest();
    List<Account> accounts = [SELECT ID, Name FROM Account WHERE Name = :name];
    System.assertEquals(1, accounts.size(), 'Expected 1 account');
    System.assert(accounts[0].Name == name);
  }
}
