/**
 * @description       :
 * @author            : arieend@gmail.com
 * @group             :
 * @last modified on  : 07/10/2020
 * @last modified by  : arieend@gmail.com
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   07/10/2020   arieend@gmail.com   Initial Version
 **/
@isTest
public with sharing class AccountServiceLayerTest {
  @IsTest
  static void doSomethingAndLogPositive() {
    Test.startTest();
    AccountServiceLayer.doSomethingAndLog('Hello Stream viewers');
    Test.stopTest();
    System.assertEquals(
      'Hello Stream viewers',
      AccountServiceLayer.didExecuteMethod,
      'Excpected the log to match input parameter'
    );
  }
  @IsTest
  static void incrementDescriptionPositiveTest() {
    List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
      new Account(),
      5
    );
    Test.startTest();
    List<Account> updatedAccounts = AccountServiceLayer.incrementDescription(
      accounts,
      false
    );
    Test.stopTest();
    for (Account acct : updatedAccounts) {
      System.assert(
        Integer.valueOf(acct.description) == 1,
        'Expected incremented by 1'
      );
    }
  }
  @isTest
  static void incrementDescriptionPositiveTest_InvalidInteger() {
    List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
      new Account(description = 'Hello'),
      5
    );
    Test.startTest();
    List<Account> updatedAccounts = AccountServiceLayer.incrementDescription(
      accounts,
      false
    );
    Test.stopTest();
    for (Account acct : updatedAccounts) {
      System.assert(
        Integer.valueOf(acct.description) == 1,
        'Expected incremented by 1'
      );
    }
  }
  @isTest
  static void incrementDescriptionNegativeTest_InvalidInteger_Save() {
    List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
      new Account(description = 'Hello'),
      5
    );
    Boolean didCatchProperException = false;
    try {
      Test.startTest();
      AccountServiceLayer.incrementDescription(accounts, true);
      Test.stopTest();
    } catch (AccountServiceLayer.ASLException asle) {
      if (asle.getMessage().containsIgnoreCase('id not specified')) {
        didCatchProperException = true;
      }
    }
    System.assert(didCatchProperException, 'Excpected exception to be thrown');
  }
  @IsTest
  static void safelySaveTest() {
    Boolean didCatchProperException = false;
    List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
      new Account(description = 'Hello'),
      5
    );
    try {
      Test.startTest();
      AccountServiceLayer.safelySave(accounts);
      Test.stopTest();
    } catch (AccountServiceLayer.ASLException dmlException) {
      didCatchProperException = true;
    }
    System.assert(didCatchProperException, 'Excpected exception to be thrown');
  }
}
