global class ScheduleApexRecipes implements Schedulable {
  @TestVisible
  private static final String testCronStatment = '0 0 0 28 5 ? 2021';
  global void execute(SchedulableContext sc) {
    ScheduleApexDemo demo = new ScheduleApexDemo();
    demo.runAtMidnight();
  }
}
