
***Fleet Managment System***

I have created an app named 'Fleet Management' in the Salesforce platform with custom objects, apex trigger,Apex controllers and a LWC component.

This sample app is meant to provide working examples of how to create a Fleet Management System for these vehicles to ensure that they are operating efficiently and reducing costs. 

**Configuration**

This repository includes all the custom code, custom metadata and a custom label. 

**Code Structure**

This project contains 1 Apex trigger, 1 Batch Apex class, 1 Batch Apex Schduler, 1 Helper class for the Apex trigger and one Lightning Web Component.  
BusTrigger & BusTriggerHandler(Apex Trigger: These are used to calculate the resale value of the bus based on certain conditions. 
MainteinanceVisitBatch : This batch is used to schedule a nightly job that creates a scheduled maintenance visit to the closest garage.
MainteinanceVisitScheduler : Scheduler to run the MainteinanceVisitBatch batch apex 
fM_BusDetails.html, fM_BusDetails.css, fM_BusDetails.js, FM_BusDetailsController: Used to build a page that lists all the buses in the fleet, which should display them as a grid of cards with few other requirements.

**Custom Metadata Types**

The project contains a custom metadata type called ‘Resale_Calculator__mdt’. The following fields are created:
	- AC_Increase__c
	- Capacity__c
	- Historic_Increase__c
	- Resale_Value__c
This has been used in the apex trigger BusTriggerHandler to store the values given in the project requirement.  

**Custom Labels**

This project contains below custom labels which are being used in the code to avoid hardcoded references.
	- Resale_Historic_Year
	- Excess_Miles_for_Resale

**Custom Object**
Three custom objects have been created to store the information of Bus, Maintenaince and Grage. Below I have provided the api names for the three objects along with their fields.  

Bus__c
	 Bus_Image__c
	 Current_Status__c
	 Has_air_conditioning__c
	 Last_Ping_Location__c
	 Maximum_Capacity__c
	 Number_of_wheels__c
	 OdometerReading__c
	 Resale_Value__c
	 Year__c

Garage__c:
	Location__c
	Bus__c
	Name

Maintenance__c:
	Bus__c
	Garage__c
	Braking_fluid_level__c
	Oil_level__c	
	Recorded_Odometer__c
	Schedule_reason__c
	Schedule_Time__c
	Tire_conditions__c

**Notes**
LWC compoent is created as a tab in the Fleet Management System app. If you click on the app, you will see all the buses displayed in grid format. 
I scheduled batch apex to run every night, at 10 PM. Below is the code that needs to be executed to scheldue a batch apex in Execute Anonymous Window.

**system.schedule('MaintenainceVisitScheduler '+today(), '0 0 22 * * ? *',new MainteinanceVisitScheduler());**
