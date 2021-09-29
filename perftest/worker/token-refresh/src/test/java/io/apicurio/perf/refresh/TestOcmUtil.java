package io.apicurio.perf.refresh;

public class TestOcmUtil {

    public static void main(String[] args) {
        String offlineToken = System.getenv("OFFLINE_TOKEN");
        if (offlineToken == null) {
            throw new RuntimeException("Required ENV var missing: OFFLINE_TOKEN");
        }
        Token token = OcmUtil.getToken("ocm", "staging", offlineToken);
        System.out.println("Token: " + token.getJwt());
        System.out.println("Expires: " + token.getExpiresOn());
    }

}
