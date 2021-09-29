package io.apicurio.perf.refresh;

public class TokenRefreshTest {

    public static void main(String[] args) {
        String offlineToken = System.getenv("OFFLINE_TOKEN");
        if (offlineToken == null) {
            throw new RuntimeException("Required ENV var missing: OFFLINE_TOKEN");
        }
        String jwt = TokenRefresh.getFleetManagerToken("ocm", "staging", offlineToken);
        System.out.println("JWT: " + jwt);

        jwt = TokenRefresh.getFleetManagerToken("ocm", "staging", offlineToken);
        System.out.println("JWT: " + jwt);

        jwt = TokenRefresh.getFleetManagerToken("ocm", "staging", offlineToken);
        System.out.println("JWT: " + jwt);
    }

}
