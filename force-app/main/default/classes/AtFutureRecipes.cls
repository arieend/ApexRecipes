/*************************************************************************************************************
 * @name			AtFutureRecipes
 * @author			arieend <arieend@gmail.com>
 * @created			05 / 10 / 2020
 * @description		Recipe serialization/deserialization of json representation
 *
 * Changes (version)
 * -----------------------------------------------------------------------------------------------------------
 * 				No.		Date			Author					Description
 * 				----	------------	--------------------	----------------------------------------------
 * @version		1.0		2020-10-05		arieend					Changes desription
 *
 **************************************************************************************************************/
public with sharing class AtFutureRecipes {
  @future
  public static void basicAtFutureCall(String data) {
    System.debug('\n\n The data is: \n' + data);
  }
  @future(callout=true)
  public static void atFutureCallout(String url, ID accountId) {
    Account account = [
      SELECT Id, name, description
      FROM Account
      WHERE Id = :accountId
    ];
    // for negative 'CalloutException' test example
    // runnig DML before HTTP
    // =======================
    // account.name += ' Modified';
    //update account;

    Http h = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(url);
    request.setMethod('GET');

    HttpResponse response = h.send(request);

    account.Description = response.getBody();
    update account;
  }
}
