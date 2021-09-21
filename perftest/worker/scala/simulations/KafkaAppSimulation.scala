package simulations


import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

// This simulation assumes there are 100k artifacts already added to the storage.
class KafkaAppSimulation extends Simulation {

  val tokenUrl = scala.util.Properties.envOrElse("TOKEN_URL", "")
  val clientId = scala.util.Properties.envOrElse("CLIENT_ID", "")
  val clientSecret = scala.util.Properties.envOrElse("CLIENT_SECRET", "")

  val registryUrl = scala.util.Properties.envOrElse("REGISTRY_URL", "http://localhost:8080/apis/registry/v2")
  val users = scala.util.Properties.envOrElse("TEST_USERS", "100").toInt
  val ramp = scala.util.Properties.envOrElse("TEST_RAMP_TIME", "60").toInt
  val iterations = scala.util.Properties.envOrElse("TEST_ITERATIONS", "10").toInt

  val httpProtocol = http
    .acceptHeader("*/*")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

  val authHeaders = Map(
    "Authorization" -> "Bearer ${access_token}"
  );

  val rando = new java.security.SecureRandom()

  val scn = scenario("Kafka App Simulation")
    // 1. Get an access token from the IDP
    .exec(http("Get access token")
      .post(tokenUrl)
      .header("Content-Type", "application/x-www-form-urlencoded")
      .body(StringBody(s"grant_type=client_credentials&client_id=${clientId}&client_secret=${clientSecret}"))
      .asJson
      .check(status.is(200))
      .check(jsonPath("$.access_token").saveAs("access_token"))
    )

    // 2. Set a unique random index per user
    .exec(session => session.set("idx", "" + (rando.nextInt(users * 2) + 100)))

    // 3. Create a new artifact with the unique index as the artifact ID
    .exec(http("Create artifact")
        .post(registryUrl + "/groups/default/artifacts")
        .headers(authHeaders)
        .header("X-Registry-ArtifactId", "KafkaAppArtifact-${idx}")
        .queryParam("ifExists", "RETURN")
        .body(StringBody("{ \"openapi\": \"3.0.2\", \"info\": { \"title\": \"Test Artifact ${idx}\"  } }"))
        .check(jsonPath("$.globalId").saveAs("globalId"))
        .check(jsonPath("$.contentId").saveAs("contentId"))
        .check(jsonPath("$.id").saveAs("artifactId"))
    )

    // 4. Fetch the artifact a bunch of times
    .repeat(iterations)(
        exec(http("Get artifact by ID")
          .get(registryUrl + "/ids/globalIds/${globalId}")
          .headers(authHeaders)
        )
        .pause(1)
    )

  setUp(
      scn.inject(rampUsers(users) during (ramp seconds))
  ).protocols(httpProtocol)
}
