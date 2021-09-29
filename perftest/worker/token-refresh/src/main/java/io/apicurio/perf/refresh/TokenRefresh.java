package io.apicurio.perf.refresh;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class TokenRefresh {

    private static Map<String, Token> cache = new HashMap<>();

    public static synchronized String getFleetManagerToken(String ocmPath, String ocmUrl, String offlineToken) {
        System.out.println("---");
        System.out.println("Getting fleet manager token...");
        System.out.println(" OCM_PATH: " + ocmPath);
        System.out.println(" OCM_URL:  " + ocmUrl);
        System.out.println(" OFFLINE_TOKEN: " + offlineToken.substring(0, 8) + "..." + offlineToken.substring(offlineToken.length() - 8));
        System.out.println("---");
        Token token = cache.get(offlineToken);

        if (token == null || hasExpired(token)) {
            token = OcmUtil.getToken(ocmPath, ocmUrl, offlineToken);
            cache.put(offlineToken, token);
        }

        String jwt = token.getJwt();
        System.out.println("Fleet manager token acquired: " + jwt.substring(0, 8) + "..." + jwt.substring(jwt.length() - 8));

        return jwt;
    }

    private static boolean hasExpired(Token token) {
        // Give a 10s grace period for the token
        return token.getExpiresOn().before(new Date(System.currentTimeMillis() - (10 * 1000)));
    }


}
