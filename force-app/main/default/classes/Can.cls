/**
 * @description       :
 * @author            : arieend@gmail.com
 * @group             :
 * @last modified on  : 10/10/2020
 * @last modified by  : arieend@gmail.com
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   08/10/2020   arieend@gmail.com   Initial Version
 **/
public with sharing class Can {
  private static Map<String, Set<sObjectField>> accessable = new Map<String, Set<sObjectField>>();
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
   * @description  Calculate whether or not filed is accessable
   * @author arieend@gmail.com | 09/10/2020
   * @param obj - the object inquestion in string form
   * @param field - filed in question in sObjectField form
   * @return Boolean
   **/
  public static Boolean fls(String obj, sObjectField field) {
    return Can.getAccessable(obj).contains(field);
  }
  /**
   * @description Memorization (Caching) of all accessable fields for given object
   * @author arieend@gmail.com | 09/10/2020
   * @param objType
   * @return Set<sObjectField>
   **/
  public static Set<sObjectField> getAccessable(String objType) {
    Schema.DescribeSObjectResult[] descResults;
    if (!Can.accessable.containsKey(objType)) {
      descResults = Schema.describeSObjects(new List<String>{ objType });
      Set<sObjectField> accessableFields = new Set<sObjectField>();
      for (SObjectField field : descResults[0].fields.getMap().values()) {
        DescribeFieldResult fieldResult = field.getDescribe();
        if (fieldResult.isAccessible()) {
          accessableFields.add(field);
        }
      }
      Can.accessable.put(objType, accessableFields);
    }
    return Can.accessable.get(objType);
  }
}
