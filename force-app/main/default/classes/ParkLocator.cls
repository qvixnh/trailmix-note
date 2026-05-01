public class ParkLocator {
    public static List<String> country(String country) {
        ParkService.ParksImplPort stub = new ParkService.ParksImplPort();
        return stub.byCountry(country);
    }
}
