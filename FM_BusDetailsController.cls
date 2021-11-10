public with sharing class FM_BusDetailsController {
  
  @AuraEnabled
  public static List<Bus__c> getBusDetails(){

      return [SELECT id,Name,Year__c,Maximum_Capacity__c,Bus_Image__c,OdometerReading__c,Resale_Value__c FROM Bus__c ];
      
  }

  
}