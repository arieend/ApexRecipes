public with sharing class ScheduleApexDemo {
  @TestVisible
  private Integer counter = 0;
  public ScheduleApexDemo() {
  }
  public void runAtMidnight() {
    System.debug('Illustrate code separation');
    this.counter = 0;
    this.counter++;
  }
}
