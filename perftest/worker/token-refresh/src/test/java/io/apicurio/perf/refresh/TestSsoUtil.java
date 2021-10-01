package io.apicurio.perf.refresh;

public class TestSsoUtil {

    public static void main(String[] args) {
        String tokenUrl = System.getenv("TOKEN_URL");
        String clientId = System.getenv("CLIENT_ID");
        String clientSecret = System.getenv("CLIENT_SECRET");
        if (tokenUrl == null) {
            throw new RuntimeException("Required ENV var missing: TOKEN_URL");
        }
        if (clientId == null) {
            throw new RuntimeException("Required ENV var missing: CLIENT_ID");
        }
        if (clientSecret == null) {
            throw new RuntimeException("Required ENV var missing: CLIENT_SECRET");
        }

        Token token = SsoUtil.getToken(tokenUrl, clientId, clientSecret);
        System.out.println("Token: " + token.getJwt());
        System.out.println("Expires: " + token.getExpiresOn());
    }

}
