trigger BusTrigger on Bus__c (before insert, before update) {
    for(Bus__c bus : Trigger.New) {
        if (bus.Current_Status__c  == 'Ready For Use'){
            
            BusTriggerHandler.calculateResaleValue(bus);
            
        }
        else{
           BusTriggerHandler.calculateResaleValue(bus); 
        }
        
    }
}