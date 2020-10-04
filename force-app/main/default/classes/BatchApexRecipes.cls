public with sharing class BatchApexRecipes implements Database.Batchable<sObject> {
  public class BatchApexException extends Exception {
  }
  private static final String queryString = 'SELECT Id, Name FROM Account';

  @TestVisible
  private Boolean throwUpdate = false;

  public Database.QueryLocator start(Database.BatchableContext context) {
    return Database.getQueryLocator(queryString);
  }
  public void execute(Database.BatchableContext context, List<Account> scope) {
    for (Account account : scope) {
      account.name += 'Edited by Batch class / job on Code Live';
      if (this.throwUpdate) {
        account.name = null;
      }
    }
    try {
      update scope;
    } catch (DMLException dmlException) {
      throw new BatchApexException(dmlException.getMessage());
    }
  }
  public void finish(Database.BatchableContext context) {
    System.debug('Hey! Finished.');
  }
}
