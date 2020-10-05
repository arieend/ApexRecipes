@isTest
public with sharing class ScheduleApexDemoTest {
  @IsTest
  static void counterTest() {
    ScheduleApexDemo demoObject = new ScheduleApexDemo();
    Test.startTest();
    demoObject.runAtMidnight();
    Test.stopTest();
    System.assertEquals(1, demoObject.counter, 'Expected 1 counter');
  }
}
