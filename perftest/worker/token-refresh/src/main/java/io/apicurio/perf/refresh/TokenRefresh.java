package io.apicurio.perf.refresh;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class TokenRefresh {

    private static Map<String, Token> tokenCache = new HashMap<>();

    public static synchronized String getFleetManagerToken(String ocmPath, String ocmUrl, String offlineToken) {
        String tokenKey = "ocm:" + ocmUrl + "#" + offlineToken;
        Token token = tokenCache.get(tokenKey);

        if (token == null || hasExpired(token)) {
            token = OcmUtil.getToken(ocmPath, ocmUrl, offlineToken, false);
            tokenCache.put(tokenKey, token);

            String jwt = token.getJwt();
            System.out.println("Fleet manager token refreshed: " + jwt.substring(0, 8) + "..." + jwt.substring(jwt.length() - 8));
        }

        return token.getJwt();
    }

    public static synchronized String getSsoToken(String tokenUrl, String clientId, String clientSecret) {
        String tokenKey = "sso:" + tokenUrl + "#" + clientId;
        Token token = tokenCache.get(tokenKey);

        if (token == null || hasExpired(token)) {
            token = SsoUtil.getToken(tokenUrl, clientId, clientSecret);
            tokenCache.put(tokenKey, token);

            String jwt = token.getJwt();
            System.out.println("SSO token refreshed: " + jwt.substring(0, 8) + "..." + jwt.substring(jwt.length() - 8));
        }

        return token.getJwt();
    }

    private static boolean hasExpired(Token token) {
        // Give a 30s grace period for the token
        return token.getExpiresOn().before(new Date(System.currentTimeMillis() - (30 * 1000)));
    }


}
