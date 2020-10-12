/**
 * @description       :
 * @author            : arieend@gmail.com
 * @group             :
 * @last modified on  : 12/10/2020
 * @last modified by  : arieend@gmail.com
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   12/10/2020   arieend@gmail.com   Initial Version
 **/
@IsTest
public with sharing class RestClientTest {
  @IsTest
  static void testRestClientGet404() {
    RestClient client = new RestClient();
    Boolean didCatchProperException = false;
    HTTPMockFactory mock = new HTTPMockFactory(
      404,
      'Not Found',
      'Body404',
      new Map<String, String>{ 'key' => 'value' }
    );
    Test.setMock(HttpCalloutMock.class, mock);
    Test.startTest();
    String result = client.get('https://developer.salesforce.com');
    Test.stopTest();
    System.assert(
      result.containsIgnoreCase('Failed to recieve'),
      'Expected contains failed message'
    );
  }
  @IsTest
  static void testRestClientGet() {
    RestClient client = new RestClient();
    Boolean didCatchProperException = false;
    HTTPMockFactory mock = new HTTPMockFactory(
      200,
      'OK',
      'Body200',
      new Map<String, String>{ 'key' => 'value' }
    );
    Test.setMock(HttpCalloutMock.class, mock);
    Test.startTest();
    String result = client.get('https://developer.salesforce.com');
    Test.stopTest();
    System.assertEquals('Body200', result, 'Expected match');
  }
}
