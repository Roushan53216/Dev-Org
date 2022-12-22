public with sharing class PromiseExmp {

    @AuraEnabled
  public static String method1() {
    return 'Hello';
  }
  @AuraEnabled
  public static String method2(String param) {
    return param + ' World';
  }
  @AuraEnabled
  public static String method3(String param) {
    return param + ' 3';
  }

}