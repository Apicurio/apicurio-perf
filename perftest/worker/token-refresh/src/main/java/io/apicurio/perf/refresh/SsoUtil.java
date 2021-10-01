package io.apicurio.perf.refresh;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

public class SsoUtil {

    private static final ObjectMapper mapper = new ObjectMapper();

    /**
     * Get an OAuth token using client_credentials flow.
     * @param tokenUrl
     * @param clientId
     * @param clientSecret
     */
    @SuppressWarnings("unchecked")
    public static Token getToken(String tokenUrl, String clientId, String clientSecret) {
        try {
            HttpRequest request = HttpRequest.newBuilder(new URI(tokenUrl))
                .POST(BodyPublishers.ofString(String.format("grant_type=client_credentials&client_id=%s&client_secret=%s", clientId, clientSecret)))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .version(HttpClient.Version.HTTP_1_1)
                .build();

            HttpResponse<String> response = HttpClient.newHttpClient().send(request, BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (response.statusCode() != 200) {
                throw new RuntimeException("Failed to get token from SSL: " + response.statusCode());
            }
            Map<String, Object> body = mapper.readValue(response.body(), Map.class);
            String jwt = body.get("access_token").toString();

            Token token = new Token();
            token.setJwt(jwt);
            token.setExpiresOn(JwtUtil.extractExpiration(jwt));
            return token;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
