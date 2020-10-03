/*************************************************************************************************************
 * @name		   	SOQLRecipes
 * @author			arieend <arieend@gmail.com>
 * @created			03 / 10 / 2020
 * @description Learn new technology, patterns, and best practices for solving practical problems with code.e
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2020-10-03		arieend					Changes desription
 *
 **************************************************************************************************************/
public with sharing class SOQLRecipes {
  public static List<Account> querySingleObject() {
    List<Account> accounts = [
      SELECT Name, ShippingStreet, ShippingCity
      FROM Account
      WITH SECURITY_ENFORCED
    ];
    return accounts;
  }
  public static Integer QueryMassiveNummberOfRecordsReturningCount() {
    Integer count = 0;
    for (Account acct : [SELECT name FROM Account WITH SECURITY_ENFORCED]) {
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
      WITH SECURITY_ENFORCED
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
      WITH SECURITY_ENFORCED
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
      WITH SECURITY_ENFORCED
      ORDER BY Industry DESC
      LIMIT :wantedNumberOfRows
    ];
  }
  public static List<Account> getAccountsInState(String state) {
    // getAccountsInState('Alabama');
    return [
      SELECT Name
      FROM Account
      WHERE ShippingState = :state
      WITH SECURITY_ENFORCED
    ];
  }
  public static List<Account> getSecond10Account() {
    return [
      SELECT Name
      FROM Account
      WITH SECURITY_ENFORCED
      ORDER BY Industry DESC
      LIMIT 10
      OFFSET 10
    ];
  }
  // Parent to child relationship
  public static List<Account> getContactsAndAccounts() {
    return [
      SELECT Name, (SELECT Name, AccountId FROM Contacts)
      FROM Account
      WITH SECURITY_ENFORCED
    ];
  }
  // Child to parent query
  public static List<Contact> getParentDetailsForChild() {
    return [
      SELECT Id, Name, Email, account.Name, account.ShippingState
      FROM Contact
      WHERE account.ShippingState = 'Kansas'
      WITH SECURITY_ENFORCED
    ];
  }
  // Junction objects are the child of two master details
  public static List<Junction__c> getDetailsFromBothParents() {
    return [
      SELECT ID, parent1__r.name, parent2__r.name
      FROM Junction__c
      WITH SECURITY_ENFORCED
    ];
  }
  public static Double getSumOfOpportunities(ID accountId) {
    // given an accountId calculate the sum of opportunitie values
    // get opportunitie and sum them!
    AggregateResult[] groupedResults = [
      SELECT SUM(Amount) total
      FROM Opportunity
      WHERE AccountId = :accountId
      WITH SECURITY_ENFORCED
    ];
    return (double) groupedResults[0].get('total');
  }
}
