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
public with sharing class AccountServiceLayer {
  public class ASLException extends Exception {
  }
  @TestVisible
  private static String didExecuteMethod;
  public static void doSomethingAndLog(string toLog) {
    System.debug(
      System.LoggingLevel.INFO,
      'Accout ID =  and Log statement = ' + toLog
    );
    AccountServiceLayer.didExecuteMethod = toLog;
  }
  public static List<Account> incrementDescription(
    List<Account> incrementAccounts,
    Boolean save
  ) {
    for (Account account : incrementAccounts) {
      Integer counter = 0;
      try {
        if (account.description != null) {
          counter = Integer.valueOf(account.description);
        }
      } catch (System.TypeException e) {
      }
      counter++;
      account.description = String.valueOf(counter);
    }
    if (save) {
      safelySave(incrementAccounts);
    }
    return incrementAccounts;
  }
  @TestVisible
  private static void safelySave(List<Account> accounts) {
    try {
      update accounts;
    } catch (DMLException dmlException) {
      System.debug(
        System.LoggingLevel.INFO,
        'DML error: ' + dmlException.getMessage()
      );
      throw new ASLException(dmlException.getMessage());
    }
  }
}
