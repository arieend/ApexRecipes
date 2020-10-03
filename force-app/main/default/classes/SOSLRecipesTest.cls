@isTest
private class SOSLRecipesTest {
  @TestSetup
  static void makeData() {
    Account a1 = new Account(Name = 'Kansas');
    Account a2 = new Account(Name = 'Bob', ShippingState = 'Kansas');
    Account a3 = new Account(Name = 'Oz');

    insert new List<Account>{ a1, a2, a3 };

    Contact c1 = new Contact(AccountId = a1.id, LastName = 'Kansas');
    Contact c2 = new Contact(AccountId = a2.id, LastName = 'Alaska');
    Contact c3 = new Contact(AccountId = a3.id, LastName = 'Ted ');

    insert new List<Contact>{ c1, c2, c3 };
    System.assertEquals(
      3,
      [SELECT ID FROM Account].size(),
      'Expected to find 3 accounts'
    );
    System.assertEquals(
      3,
      [SELECT ID FROM Contact].size(),
      'Expected to find 3 contacts'
    );
  }
  @IsTest
  static void basicSOSLSearchTest() {
    Map<ID, Account> accKansas = new Map<ID, Account>([SELECT ID FROM ACCOUNT]);
    Map<ID, Contact> ctsKansas = new Map<ID, Contact>([SELECT ID FROM CONTACT]);
    List<ID> fixedSearchResults = new List<Id>();
    fixedSearchResults.addAll(new List<ID>(accKansas.keySet()));
    fixedSearchResults.addAll(new List<ID>(ctsKansas.keySet()));
    Test.setFixedSearchResults(fixedSearchResults);
    Test.startTest();
    List<List<sObject>> results = SOSLRecipes.basicSOSLSearch();
    Test.stopTest();
    System.debug(results);
    System.assertEquals(3, results[0].size(), 'Expected to find 3 result');
  }
  @IsTest
  static void nameFieldSearchTest() {
    Map<ID, Contact> ctMap = new Map<ID, Contact>(
      [SELECT ID FROM CONTACT WHERE LastName = 'Alaska']
    );
    Test.setFixedSearchResults(new List<Id>(ctMap.keySet()));
    Test.startTest();
    List<List<sObject>> results = SOSLRecipes.nameFieldSearch();
    Test.stopTest();
    System.assertEquals(1, results[1].size(), 'Expected to find 1 result');
  }
}
