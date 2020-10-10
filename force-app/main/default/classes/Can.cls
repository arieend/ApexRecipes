/**
 * @description       :
 * @author            : arieend@gmail.com
 * @group             :
 * @last modified on  : 11/10/2020
 * @last modified by  : arieend@gmail.com
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   08/10/2020   arieend@gmail.com   Initial Version
 **/
public with sharing class Can {
  @TestVisible
  private static Map<String, Map<String, Set<String>>> flsMapByObject = new Map<String, Map<String, Set<String>>>();
  /**
   * @description  Check sObject for CRUD action
   * @author arieend@gmail.com | 08/10/2020
   * @param obj - obj type to check
   * @param permission - create, read , update or delete
   * @return Boolean
   **/
  public static Boolean crud(sObject obj, String permission) {
    switch on (permission) {
      when 'create' {
        return obj.getSObjectType().getDescribe().isCreateable();
      }
      when 'read' {
        return obj.getSObjectType().getDescribe().isAccessible();
      }
      when 'update' {
        return obj.getSObjectType().getDescribe().isUndeletable();
      }
      when 'delete' {
        return obj.getSObjectType().getDescribe().isDeletable();
      }
      when else {
        return false;
      }
    }
  }
  /**
   * @description Convienen API for determining if running user can create the specified object
   * @author arieend@gmail.com | 10/10/2020
   * @param obj
   * @return Boolean
   **/
  public static Boolean create(sObject obj) {
    return Can.crud(obj, 'create');
  }
  /**
   * @description Convienen API for determining if running user can read the specified object
   * @author arieend@gmail.com | 10/10/2020
   * @param obj
   * @return Boolean
   **/
  public static Boolean read(sObject obj) {
    return Can.crud(obj, 'read');
  }
  /**
   * @description Convienen API for determining if running user can update the specified object
   * @author arieend@gmail.com | 10/10/2020
   * @param obj
   * @return Boolean
   **/
  public static Boolean edit(sObject obj) {
    return Can.crud(obj, 'update');
  }
  /**
   * @description Convienen API for determining if running user can delete the specified object
   * @author arieend@gmail.com | 10/10/2020
   * @param obj
   * @return Boolean
   **/
  public static Boolean destroy(sObject obj) {
    return Can.crud(obj, 'delete');
  }
  /**
   * @description  Calculate FLS
   * @author arieend@gmail.com | 09/10/2020
   * @param obj - the object inquestion in string form
   * @param field - filed in question in String form
   * @return Boolean
   **/
  public static Boolean fls(String obj, String field, String action) {
    return Can.flsMemorize(obj, action).contains(field);
  }
  /**
   * @description  Calculate FLS  - accessible
   * @author arieend@gmail.com | 09/10/2020
   * @param obj - the object inquestion in string form
   * @param field - filed in question in String form
   * @return Boolean
   **/
  public static Boolean flsAccessible(String obj, String field) {
    return Can.fls(obj, field, 'Accessible');
  }
  /**
   * @description  Calculate FLS  - updateable
   * @author arieend@gmail.com | 09/10/2020
   * @param obj - the object inquestion in string form
   * @param field - filed in question in String form
   * @return Boolean
   **/
  public static Boolean flsUpdateable(String obj, String field) {
    return Can.fls(obj, field, 'Updateable');
  }
  /**
   * @description Memorization (Caching) of all accessable fields for given object
   * @author arieend@gmail.com | 09/10/2020
   * @param obj - the object inquestion in string form
   * @param actio - Accessible , Updateable
   * @return Set<sObjectField>
   **/
  @TestVisible
  private static Set<String> flsMemorize(String objType, String action) {
    Map<String, Set<String>> flsMap;
    Schema.DescribeSObjectResult[] descResults;

    if (!flsMapByObject.containsKey(action)) {
      flsMapByObject.put(action, new Map<String, Set<String>>());
    }
    flsMap = flsMapByObject.get(action);

    if (!flsMap.containsKey(objType)) {
      descResults = Schema.describeSObjects(new List<String>{ objType });
      Set<String> flsFields = new Set<String>();
      for (SObjectField field : descResults[0].fields.getMap().values()) {
        DescribeFieldResult fieldResult = field.getDescribe();
        switch on action {
          when 'Accessible' {
            if (fieldResult.isAccessible()) {
              flsFields.add(String.valueOf(field));
            }
          }
          when 'Updateable' {
            if (fieldResult.isUpdateable()) {
              flsFields.add(String.valueOf(field));
            }
          }
        }
      }
      flsMap.put(objType, flsFields);
    }
    return flsMap.get(objType);
  }
}
