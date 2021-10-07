package io.apicurio.perf.refresh;

public class TokenRefreshTest {

    public static void main(String[] args) {
        String offlineToken = System.getenv("OFFLINE_TOKEN");
        String tokenUrl = System.getenv("TOKEN_URL");
        String clientId = System.getenv("CLIENT_ID");
        String clientSecret = System.getenv("CLIENT_SECRET");


        if (offlineToken == null) {
            throw new RuntimeException("Required ENV var missing: OFFLINE_TOKEN");
        }
        if (tokenUrl == null) {
            throw new RuntimeException("Required ENV var missing: TOKEN_URL");
        }
        if (clientId == null) {
            throw new RuntimeException("Required ENV var missing: CLIENT_ID");
        }
        if (clientSecret == null) {
            throw new RuntimeException("Required ENV var missing: CLIENT_SECRET");
        }


        String jwt = TokenRefresh.getFleetManagerToken("ocm", "staging", offlineToken);
        System.out.println("Fleet Manager JWT: " + jwt);
        jwt = TokenRefresh.getFleetManagerToken("ocm", "staging", offlineToken);
        System.out.println("Fleet Manager JWT: " + jwt);
        jwt = TokenRefresh.getFleetManagerToken("ocm", "staging", offlineToken);
        System.out.println("Fleet Manager JWT: " + jwt);


        jwt = TokenRefresh.getSsoToken(tokenUrl, clientId, clientSecret);
        System.out.println("SSO JWT: " + jwt);
        jwt = TokenRefresh.getSsoToken(tokenUrl, clientId, clientSecret);
        System.out.println("SSO JWT: " + jwt);

    }

}
