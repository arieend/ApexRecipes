@isTest
public with sharing class ScheduleApexRecipesTest {
  @IsTest
  static void scheduledExecutionTimeIsCorrectPositive() {
    Test.startTest();
    String scheduleJobId = System.schedule(
      'ScheduleApexRecipes-Test',
      ScheduleApexRecipes.testCronStatment,
      new ScheduleApexRecipes()
    );
    Test.stopTest();

    CronTrigger checkCronTrigger = [
      SELECT CronExpression, timesTriggered, nextFireTime
      FROM CronTrigger
      WHERE id = :scheduleJobId
      LIMIT 1
    ];
    System.assertEquals(
      0,
      checkCronTrigger.timesTriggered,
      'Excpected this cron trigger never have been fired'
    );
    System.assertEquals(
      checkCronTrigger.CronExpression,
      ScheduleApexRecipes.testCronStatment,
      'Excpected CronExpression to be equal to testCronStatment'
    );
    System.assertEquals(
      dateTime.newInstance(2021, 5, 28, 0, 0, 0),
      checkCronTrigger.nextFireTime
    );
  }
}
