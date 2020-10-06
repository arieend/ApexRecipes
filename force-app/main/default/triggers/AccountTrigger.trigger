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
trigger AccountTrigger on Account(before insert, after insert) {
  new AccountTriggerHandler().run();

}
