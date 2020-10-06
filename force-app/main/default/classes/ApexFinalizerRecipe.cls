/**
 * @description       : Dummy for fanilizer recipe example
 *                      Finalizers allow you to attach code - this code - to be run at the end of queueable
 * @author            : arieend@gmail.com
 * @group             :
 * @last modified on  : 07/10/2020
 * @last modified by  : arieend@gmail.com
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   07/10/2020   arieend@gmail.com   Initial Version
 **/
public with sharing class ApexFinalizerRecipe implements Finalizer {
  /**
   * @description This is required method by Finalizer interface
   * @author arieend@gmail.com | 07/10/2020
   * @param  context
   **/
  public void execute(FinalizerContext context) {
    ApexFinalizerRecipeExecution.finalizerHasBeenExecuted = true;
  }
}
