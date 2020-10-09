/**
 * @description       :
 * @author            : arieend@gmail.com
 * @group             :
 * @last modified on  : 10/10/2020
 * @last modified by  : arieend@gmail.com
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   09/10/2020   arieend@gmail.com   Initial Version
 **/
@isTest
public with sharing class CanTest {
  @IsTest
  static void canCrudAccountCreatePositive() {
    System.assert(
      Can.crud(new Account(), 'create'),
      'Excpected pass that means user can create account'
    );
  }
  @IsTest
  static void canCrudAccountReadPositive() {
    System.assert(
      Can.crud(new Account(), 'read'),
      'Excpected pass that means user can read account'
    );
  }
  @IsTest
  static void canCrudAccountUpdatePositive() {
    System.assert(
      Can.crud(new Account(), 'update'),
      'Excpected pass that means user can update account'
    );
  }
  @IsTest
  static void canCrudAccountDeletePositive() {
    System.assert(
      Can.crud(new Account(), 'delete'),
      'Excpected pass that means user can delete account'
    );
  }
  @IsTest
  static void canCrudAccountOtherPositive() {
    System.assert(
      !Can.crud(new Account(), 'other'),
      'Excpected not pass that means CRUD action does not exist'
    );
  }
  @IsTest
  static void canApiCreate() {
    System.assert(
      Can.create(new Account()),
      'Expect pass that means user can create account'
    );
  }
  @IsTest
  static void canApiRead() {
    System.assert(
      Can.read(new Account()),
      'Expect pass that means user can read account'
    );
  }
  @IsTest
  static void canApiEdit() {
    System.assert(
      Can.edit(new Account()),
      'Expect pass that means user can update account'
    );
  }
  @IsTest
  static void canApiDestroy() {
    System.assert(
      Can.destroy(new Account()),
      'Expect pass that means user can delete account'
    );
  }
}
