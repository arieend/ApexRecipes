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
public with sharing class AccountTriggerHandler extends TriggerHandler {
  public override void beforeInsert() {
    AccountServiceLayer.doSomethingAndLog('accountId', 'where');
  }
  public override void afterInsert() {
  }
}
