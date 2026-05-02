public class BusScheduleCache {

    private Cache.OrgPartition part;

    // Constructor
    public BusScheduleCache() {
        part = Cache.Org.getPartition('local.BusSchedule');
    }

    // Put schedule into cache
    public void putSchedule(String busLine, Time[] schedule) {
        part.put(busLine, schedule);
    }

    // Get schedule from cache
    public Time[] getSchedule(String busLine) {
        Time[] schedule = (Time[]) part.get(busLine);

        // Handle cache miss
        if (schedule == null) {
            return new Time[] {
                Time.newInstance(8, 0, 0, 0),
                Time.newInstance(17, 0, 0, 0)
            };
        }

        return schedule;
    }
}
