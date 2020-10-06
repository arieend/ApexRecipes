@isTest
public with sharing class ApexFinalizerRecipeTest {
  @IsTest
  static void executeFinalizerOnQueueableCompltion() {
    Test.startTest();
    ApexFinalizerQueueableRecipe recipe = new ApexFinalizerQueueableRecipe();
    System.enqueueJob(recipe);
    Test.stopTest();
    System.assert(
      ApexFinalizerRecipeExecution.finalizerHasBeenExecuted,
      'Excpected true'
    );
  }
}
