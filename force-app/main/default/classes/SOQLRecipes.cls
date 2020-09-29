public with sharing class SOQLRecipes {
  public static List<Account> querySingleObject() {
    List<Account> accounts = [
      SELECT Name, ShippingStreet, ShippingCity
      FROM Account
    ];
    return accounts;
  }
  public static Integer QueryMassiveNummberOfRecordsReturningCount() {
    Integer count = 0;
    for (Account acct : [SELECT name FROM Account]) {
      count++;
    }
    return count;
  }
  public static List<Account> getFilteredList() {
    // All records with a mail address of the UK
    List<Account> accounts = [
      SELECT Name
      FROM Account
      WHERE ShippingCountry = 'UK'
    ];
    return accounts;
  }
  public static List<Account> getComplexFilteredList() {
    return [
      SELECT Name
      FROM Account
      WHERE
        ShippingCountry = 'US'
        AND ShippingState = 'Indiana'
        AND (Industry = 'Fast Food - made whole'
        OR Industry = 'Slow Food - Made quickly')
    ];
  }
  public static List<Account> getSpecificNumberOfResults() {
    // LIMIT clause
    return [SELECT Name FROM Account ORDER BY Industry DESC LIMIT 10];
  }
  public static List<Account> getFirstXResult(Integer wantedNumberOfRows) {
    return [
      SELECT Name
      FROM Account
      ORDER BY Industry DESC
      LIMIT :wantedNumberOfRows
    ];
  }
  public static List<Account> getAccountsInState(String state) {
    // getAccountsInState('Alabama');
    return [SELECT Name FROM Account WHERE ShippingState = :state];
  }
  public static List<Account> getSecond10Account() {
    return [SELECT Name FROM Account ORDER BY Industry DESC LIMIT 10 OFFSET 10];
  }
  // Parent to child relationship
  public static List<Account> getContactsAndAccounts() {
    return [SELECT Name, (SELECT Name FROM Contacts) FROM Account];
  }
  // Child to parent query
  public static List<Contact> getParentDetailsForChild() {
    return [
      SELECT Id, Name, Email, account.Name, account.ShippingState
      FROM Contact
      WHERE account.ShippingState = 'Kansas'
    ];
  }
  // Junction objects are the child of two master details
  // public static List<Junction__c> getDetailsFromBothParents() {
  //   return [SELECT ID, parent1.name, parent2.name FROM Junction__c];
  // }
  // public static Double getSumOfOpportunities(ID accountId) {
  //   // given an accountId calculate the sum of opportunitie values
  //   // get opportunitie and sum them!
  //   AggregateResult[] groupedResults = [
  //     SELECT SUM(Amount) total
  //     FROM Opportunity
  //     WHERE AccountId = :accountId
  //   ];
  //   return (double) groupedResults[0].get('total');
  // }
}
