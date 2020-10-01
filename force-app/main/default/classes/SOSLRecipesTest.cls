@isTest
private class SOSLRecipesTest {
  @IsTest
  static void basicSOSLSearchTest() {
    Account a1 = new Account(Name = 'Kansas');
    Account a2 = new Account(Name = 'Bob', ShippingState = 'Kansas');
    Account a3 = new Account(Name = 'Oz');

    insert new List<Account>{ a1, a2, a3 };

    Contact c1 = new Contact(AccountId = a1.id, LastName = 'Kansas');
    Contact c2 = new Contact(AccountId = a2.id, LastName = 'Bob');
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
    List<ID> fixedSearchResults = new List<Id>{
      a1.Id,
      a2.Id,
      a3.Id,
      c1.Id,
      c2.Id,
      c3.Id
    };
    Test.setFixedSearchResults(fixedSearchResults);
    Test.startTest();
    List<List<sObject>> results = SOSLRecipes.basicSOSLSearch();
    Test.stopTest();
    System.debug(results);
    System.assertEquals(3, results[0].size(), 'Expected to find 3 result');
  }
}
