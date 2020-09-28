public with sharing class SOQLRecipes {
  public static List<Account> querySingleObject() {
    List<Account> accounts = [
      SELECT Name, MailingStreet, MailingCity
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
  public static List<Account> getFilteredLis() {
    // All records with a mail address of the UK
    List<Account> accounts = [
      SELECT Name
      FROM Account
      WHERE MailingCountry = 'UK'
    ];
    return accounts;
  }
  public static List<Account> getComplexFilteredList() {
    return [
      SELECT Name
      FROM Account
      WHERE
        MailingCountry = 'US'
        AND MailingState = 'Indiana'
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
    return [SELECT Name FROM Account WHERE mailingState = :state];
  }
  public static List<Account> getSecondTenAccount() {
    return [SELECT Name FROM Account ORDER BY Industry DESC LIMIT 10 OFFSET 10];
  }
  // Parent to child relationship
  public static List<Account> getContactsAndAccounts() {
    return [SELECT Name, (SELECT Name FROM Contacts) FROM Account];
  }
  // Child to parent query
  public static List<Account> getParentDetailsForChild() {
    return [
      SELECT Id, Name, Email, account.Name, account.mailingState
      FROM Contacts
      WHERE account.mailingState = 'Kansas'
    ];
  }
  // Junction objects are the child of two master details
  public static List<Junction__c> getDetailsFromBothParents() {
    return [SELECT ID, parent1.name, parent2.name FROM Junction__c];
  }
  public static Double getSumOfOpportunities(ID accountId) {
    // given an accountId calculate the sum of opportunitie values
    // get opportunitie and sum them!
    AggregateResult[] groupedResults = [
      SELECT SUM(Amount) total
      FROM Opportunity
      WHERE AccountId = :accountId
    ];
    return groupedResults[0].total;
  }
}
