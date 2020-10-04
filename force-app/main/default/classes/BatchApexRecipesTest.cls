@isTest
public with sharing class BatchApexRecipesTest {
  @TestSetup
  static void makeData() {
    List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
      new Account(),
      200,
      true
    );
  }
  @IsTest
  static void BatchApexRecipesTestPositive_200Scope() {
    Test.startTest();
    Database.executeBatch(new BatchApexRecipes());
    Test.stopTest();
    List<Account> checkAccounts = [SELECT Name FROM Account];
    for (Account chk : checkAccounts) {
      System.assert(chk.name.containsIgnoreCase('Edited by Batch class'));
    }
  }
  @IsTest
  static void BatchApexRecipesTestNegative() {
    Boolean didCatchProperException = false;
    BatchApexRecipes batchJob = new BatchApexRecipes();
    batchJob.throwUPdate = true;
    try {
      Test.startTest();
      Database.executeBatch(batchJob);
      Test.stopTest();
    } catch (BatchApexRecipes.BatchApexException batchApexException) {
      if (batchApexException.getMessage().containsIgnoreCase('Update failed')) {
        didCatchProperException = true;
      }
    }
    System.assert(didCatchProperException, 'Excpected exception to be thrown');
  }
  //   @IsTest
  //   static void BatchApexRecipesTestNegative_50Scope() {
  //     List<Account> accounts = (List<Account>) TestFactory.createSObjectList(
  //       new Account(),
  //       200,
  //       true
  //     );
  //     Boolean didCatchProperException = false;
  //     Test.startTest();
  //     try {
  //       Database.executeBatch(new BatchApexRecipes(), 50);
  //     } catch (System.UnexpectedException ue) {
  //       if (ue.getMessage().containsIgnoreCase('No more than one executeBatch')) {
  //         didCatchProperException = true;
  //       }
  //     }
  //     Test.stopTest();
  //     System.assert(didCatchProperException, 'Excpected exception to be thrown');
  //   }
}
