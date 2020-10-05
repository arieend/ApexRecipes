@isTest
public with sharing class AtFutureRecipesTest {
  @isTest
  static void basicAtFutureCallTest() {
    Test.startTest();
    AtFutureRecipes.basicAtFutureCall('Hello World!!!');
    Test.stopTest();
  }
  // CalloutException test example
  // =============================
  //   @IsTest
  //   static void atFutureCalloutNagative() {
  //     Account account = (Account) TestFactory.createSObject(
  //       new Account(name = 'sfdcKuku'),
  //       true
  //     );
  //     HTTPMockFactory mock = new HTTPMockFactory(
  //       200,
  //       'OK',
  //       'Hello World!!!',
  //       new Map<String, String>()
  //     );
  //     Test.setMock(HttpCalloutMock.class, mock);
  //     Boolean didCatchProperException = false;
  //     try {
  //       Test.startTest();
  //       AtFutureRecipes.atFutureCallout(
  //         'https://developer.salesforce.com',
  //         account.id
  //       );
  //       Test.stopTest();
  //     } catch (CalloutException calloutException) {
  //       if (
  //         calloutException.getMessage()
  //           .containsIgnoreCase('You have uncommitted work pending')
  //       ) {
  //         didCatchProperException = true;
  //       }
  //     }
  //     System.assert(didCatchProperException, 'Excpected exception to be thrown');
  //   }
  @IsTest
  static void atFutureCalloutPositive() {
    Account account = (Account) TestFactory.createSObject(
      new Account(name = 'sfdcKuku'),
      true
    );
    HTTPMockFactory mock = new HTTPMockFactory(
      200,
      'OK',
      'Hello World!!!',
      new Map<String, String>()
    );
    Test.setMock(HttpCalloutMock.class, mock);
    Test.startTest();
    AtFutureRecipes.atFutureCallout(
      'https://developer.salesforce.com',
      account.id
    );
    Test.stopTest();

    Account acct = [
      SELECT Id, name, description
      FROM Account
      WHERE Id = :account.id
    ];
    System.assert(
      acct.Description.containsIgnoreCase('Hello'),
      'Expected description to contain "Hello"'
    );
  }
}
