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
  private List<Account> triggerOld;
  private List<Account> triggerNew;
  public AccountTriggerHandler() {
    this.triggerOld = (List<Account>) Trigger.old;
    this.triggerNew = (List<Account>) Trigger.new;
  }
  public override void beforeInsert() {
    AccountServiceLayer.incrementDescription(this.triggerNew, false);
  }
  public override void afterInsert() {
    AccountServiceLayer.incrementDescription(this.triggerNew, true);
  }
}
