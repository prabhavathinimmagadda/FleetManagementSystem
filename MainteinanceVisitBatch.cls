global class MainteinanceVisitBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('Entered start method');
        //query all the buses with Maximum_Capacity__c=60 and OdometerReading__c > 5000
        String query = 'Select Id, Name, Last_Ping_Location__c,OdometerReading__c from Bus__c where  Maximum_Capacity__c=\'60\' AND OdometerReading__c > 5000';
        system.debug('query : '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Bus__c> bus){
        system.debug('Entered execute method');     
        system.debug('Buses : '+bus);        
        Set<Id> busIds = new Set<Id>();
        for(Bus__c b: bus){
            busIds.add(b.Id);
        }
        //get the Maintenance__c records count associated with each bus 
        Map<Id, Integer> allRelatedMainteinances = new Map<Id, Integer>();
        AggregateResult[] allMainteinances = [Select COUNT(Id), Bus__c from Maintenance__c where Bus__c IN: busIds GROUP BY Bus__c];        
        for(AggregateResult ag : allMainteinances){
           Id busId = (ID)ag.get('Bus__c');
           Integer count = (INTEGER)ag.get('expr0');
           allRelatedMainteinances.put(busId, count);
            system.debug('allRelatedMainteinances >>>> '+allRelatedMainteinances);
        }
        
        Map<Double, Garage__c> calclulateMiles = new Map<Double, Garage__c>();
        List<Maintenance__c> mntList = new List<Maintenance__c>();

        Double dist=0;
        Double distance;
        Id gargare_id ;        
        List<Garage__c> garages = [Select Id, Name, Location__c from Garage__c];
        for(Bus__c bus_record: bus){
            system.debug('Bus Name : '+bus_record.Name);
            //calculate the distance between bus's location and garage's loction to assign the bus to the closest garage
            for(Garage__c gar_record : garages){
                if(gar_record.Location__c != null && bus_record.Last_Ping_Location__c != null){
                    distance = Location.getDistance(gar_record.Location__c, bus_record.Last_Ping_Location__c, 'mi');
                }              
                system.debug('Calculating distance >>>> '+distance);
                system.debug('Garage Id >>>> '+gar_record.Id);
                if(dist== 0 || dist > distance){
                    dist = distance;
                    gargare_id = gar_record.Id;
                }
                
            } 
            Integer i = Integer.valueOf(bus_record.OdometerReading__c/5000);
            Integer new_count = 0;
            
            // get the count of Maintenance__c records that needs to be added when the batch runs
            if(allRelatedMainteinances.get(bus_record.Id)<i){
                new_count = i- allRelatedMainteinances.get(bus_record.Id);
            }
            else if(allRelatedMainteinances.get(bus_record.Id) == null){
                new_count = i;
            }
            system.debug('new_count >>> '+new_count);
            system.debug('i: '+i);
            
            //create Maintenance__c records based on the new_count value 
            for(Integer j=1; j< = new_count ; j++){
                system.debug('j: '+j);
        		Maintenance__c mnt = new Maintenance__c();
                
                mnt.Bus__c = bus_record.Id;
                mnt.Garage__c = gargare_id;
                mnt.Recorded_Odometer__c = bus_record.OdometerReading__c;
                mnt.Name = 'Scheduled Mainteinance visit '+system.now() + '_'+j;
                mnt.Schedule_reason__c = 'Scheduled Mainteinance visit '+system.now() + '_'+j;
                mnt.Oil_level__c = 'Half tank';
                mnt.Tire_conditions__c = 'Good';
                mntList.add(mnt);
            }
            system.debug('mntList >>> '+mntList);
            
            
        }
        if(!mntList.isEmpty()){
            insert mntList;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}
