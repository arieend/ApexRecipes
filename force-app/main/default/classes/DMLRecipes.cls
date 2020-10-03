/*************************************************************************************************************
 * @name			DMLRecipes
 * @author			arieend <arieend@gmail.com>
 * @created			04 / 10 / 2020
 * @description		DML recipes
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2020-10-04		arieend					Changes desription
 *
 **************************************************************************************************************/
public with sharing class DMLRecipes {
  public class CustomDMLException extends Exception {
  }
  public static void insertTheObjectKeyword(String name) {
    Account account = new Account();
    account.name = name;
    try {
      insert account;
    } catch (DMLException dmlException) {
      throw new CustomDMLException('Failed to insert account');
    }
  }
  /*********************************************************************************************************
   * @name			    insertTheObjectDatabaseMethod
   * @author			arieend <arieend@gmail.com>
   * @created			04 / 10 / 2020
   * @description	    Demonstrates Database Insert method of doing DML.
   * @param		    	String name : name passed through account created
   *                    shouldFail : determines whether or not all accounts to be inserted must insert successfully
   * @return			Explanation of the return value
   **********************************************************************************************************/
  public static void insertTheObjectDatabaseMethod(
    String name,
    boolean shouldFail
  ) {
    Account account = new Account(Name = name);
    Account account1 = new Account();

    try {
      database.insert(new List<Account>{ account, account1 }, shouldFail);
    } catch (DMLException dmlException) {
      throw new CustomDMLException('Failed with database method');
    }
  }
}
