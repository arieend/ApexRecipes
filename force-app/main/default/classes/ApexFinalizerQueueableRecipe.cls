/*************************************************************************************************************
 * @name			ApexFinalizerQueueableRecipe
 * @author			arieend <arieend@gmail.com>
 * @created			06 / 10 / 2020
 * @description		Finalizer Example
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2020-10-06		arieend					Changes desription
 *
 **************************************************************************************************************/
public with sharing class ApexFinalizerQueueableRecipe implements Queueable {
  /*********************************************************************************************************
   * @name			  execute
   * @author			arieend <arieend@gmail.com>
   * @created			06 / 10 / 2020
   * @description Excute queueable
   * @param		  	qc : Demand by queueable interface
   **********************************************************************************************************/
  public static void execute(QueueableContext qc) {
    System.debug(System.LoggingLevel.INFO, 'Run ApexFinalizerQueueableRecipe');
    ApexFinalizerRecipe afr = new ApexFinalizerRecipe();
    System.attachFinalizer(afr);
  }
}
