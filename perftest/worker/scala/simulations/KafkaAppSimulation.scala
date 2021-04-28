package simulations


import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

// This simulation assumes there are 100k artifacts already added to the storage.
class KafkaAppSimulation extends Simulation {

  val registryUrl = scala.util.Properties.envOrElse("REGISTRY_URL", "http://localhost:8080/apis/registry/v2")
  val users = scala.util.Properties.envOrElse("TEST_USERS", "100").toInt
  val ramp = scala.util.Properties.envOrElse("TEST_RAMP_TIME", "60").toInt
  val iterations = scala.util.Properties.envOrElse("TEST_ITERATIONS", "300").toInt

  val httpProtocol = http
    .baseUrl(registryUrl)
    .acceptHeader("text/html,application/xhtml+xml,application/json,application/xml;q=0.9,*/*;q=0.8")
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

  val rando = new java.security.SecureRandom()

  val scn = scenario("Kafka App Simulation")
    .exec(session => session.set("idx", "" + (rando.nextInt(users * 2) + 100)))
    .exec(http("create_artifact")
        .post("/groups/default/artifacts")
        .header("X-Registry-ArtifactId", "KafkaAppArtifact-${idx}")
        .queryParam("ifExists", "RETURN")
        .body(StringBody("{ \"openapi\": \"3.0.2\", \"info\": { \"title\": \"Test Artifact ${idx}\"  } }"))
        .check(jsonPath("$.globalId").saveAs("globalId"))
        .check(jsonPath("$.contentId").saveAs("contentId"))
        .check(jsonPath("$.id").saveAs("artifactId"))
    )

    .repeat(iterations)(
        exec(http("get_by_globalId")
          .get("/ids/globalIds/${globalId}")
        )
        .pause(1)
    )

  setUp(
      scn.inject(rampUsers(users) during (ramp seconds))
  ).protocols(httpProtocol)
}
