package io.apicurio.perf.refresh;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Date;
import java.util.Map;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JwtUtil {

    private static final ObjectMapper mapper = new ObjectMapper();

    /**
     * @param jwt
     * @return
     * @throws JsonMappingException
     * @throws JsonProcessingException
     */
    public static Date extractExpiration(String jwt) throws JsonMappingException, JsonProcessingException {
        String[] split = jwt.split("\\.");
        String payload = split[1];
        String payloadJson = new String(Base64.getUrlDecoder().decode(payload), StandardCharsets.UTF_8);

        @SuppressWarnings("unchecked")
        Map<String, Object> payloadMap = mapper.readValue(payloadJson, Map.class);
        Number number = (Number) payloadMap.get("exp");
        long millis = number.longValue() * 1000L;

        System.err.println("---");
        System.err.println("EXP: " + number);
        System.err.println("EXP millis: " + millis);
        System.err.println("EXP Date: " + new Date(millis));

        // Expire the token earlier than needed by 30s.
        Date adjExp = new Date(millis - (30 * 1000));
        System.err.println("Adj Exp Date: " + adjExp);
        System.err.println("---");
        return adjExp;
    }

}
