public with sharing class BusTriggerHandler {
    public static void calculateResaleValue(Bus__c bus){
        system.debug('Bus: '+bus);
        // this condition is added ecause it should enter the block and check all condition only when the current status is set to 'Ready For Use'
        if(bus.Current_Status__c == 'Ready For Use'){
            Decimal resale_value = 0;
            Map<String, List<Resale_Calculator__mdt>> capacities = new Map<String, List<Resale_Calculator__mdt>> ();
            System.debug('Entering');
            // query the custom metadata which has the data with filtering conditions
            for(Resale_Calculator__mdt capacity: [Select DeveloperName, MasterLabel, Historic_Increase__c, AC_Increase__c, 
                                                  Resale_Value__c from Resale_Calculator__mdt]){
                                                      if(!capacities.containsKey(capacity.MasterLabel)){
                                                          capacities.put(capacity.MasterLabel, new List<Resale_Calculator__mdt>());
                                                      }
                                                      capacities.get(capacity.MasterLabel).add(capacity);
                                                  }             
            
            System.debug('Map :: '+capacities);
            // get the specific metadata info based on the current bus record' maximum capacity that is being edited or inserted
            List<Resale_Calculator__mdt> CapacityMetadata = capacities.get(bus.Maximum_Capacity__c);
            System.debug('Metadata List is :: '+capacityMetadata);
            if(capacityMetadata!= null){
                for(Resale_Calculator__mdt capacity: CapacityMetadata) {
                    if(Bus.Has_air_conditioning__c){
                        System.debug('Bus has AC');
                        //calculate the resale value based on the Year__c on the bus record when it has air conditioning
                        if(Integer.valueOf(Bus.Year__c) <= Integer.valueOf(Label.Resale_Historic_Year)){
                            System.debug('Bus is Historic');
                            resale_value = capacity.Resale_Value__c + capacity.Resale_Value__c*capacity.AC_Increase__c/100 + capacity.Resale_Value__c*capacity.Historic_Increase__c/100;
                        }
                        else resale_value = capacity.Resale_Value__c + capacity.Resale_Value__c*capacity.AC_Increase__c/100;
                    }
                    else {
                        System.debug('Bus with no AC');
                        //calculate the resale value based on the Year__c on the bus record when the it has no air conditioning
                        if(Integer.valueOf(Bus.Year__c) <= Integer.valueOf(Label.Resale_Historic_Year)){
                            resale_value = capacity.Resale_Value__c + capacity.Resale_Value__c*capacity.Historic_Increase__c/100;
                        }
                        else resale_value = capacity.Resale_Value__c;
                    }
                } 
                //calculate the resale value based on the OdometerReading__c on the bus record
                if(bus.OdometerReading__c > Integer.valueOf(Label.Excess_Miles_for_Resale)) {
                    System.debug('Bus Odometer reading is :: '+bus.OdometerReading__c);
                    resale_value = resale_value - ((bus.OdometerReading__c-Integer.valueOf(Label.Excess_Miles_for_Resale))*0.1);
                }
                bus.Resale_Value__c = resale_value;
            }
            else{
                bus.Resale_Value__c = null; 
            }            
        }
        //when the current status is not set to 'Ready For Use', clear the Resale Value
        else{
            bus.Resale_Value__c = null;
        }
    }   
}
