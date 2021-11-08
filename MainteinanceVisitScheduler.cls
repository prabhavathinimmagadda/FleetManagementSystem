//system.schedule('MaintenainceVisitScheduler '+today(), '0 0 13/0 16/1  ? ',new MainteinanceVisitScheduler());

global class MainteinanceVisitScheduler implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        MainteinanceVisitBatch mv = new MainteinanceVisitBatch();
        Database.executeBatch(mv);
    }
}