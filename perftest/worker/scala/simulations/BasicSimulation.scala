package simulations


import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._


class BasicSimulation extends Simulation {

  val tokenUrl = scala.util.Properties.envOrElse("TOKEN_URL", "")
  val clientId = scala.util.Properties.envOrElse("CLIENT_ID", "")
  val clientSecret = scala.util.Properties.envOrElse("CLIENT_SECRET", "")

  val registryUrl = scala.util.Properties.envOrElse("REGISTRY_URL", "http://localhost:8080/apis/registry/v2")
  val users = scala.util.Properties.envOrElse("TEST_USERS", "1").toInt
  val ramp = scala.util.Properties.envOrElse("TEST_RAMP_TIME", "5").toInt

  val httpProtocol = http
    .acceptHeader("*/*")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

  val authHeaders = Map(
    "Authorization" -> "Bearer ${access_token}"
  );

  val scn = scenario("Smoke Test")
    // 1. Get an access token from the IDP
    .exec(http("Get access token")
      .post(tokenUrl)
      .header("Content-Type", "application/x-www-form-urlencoded")
      .body(StringBody(s"grant_type=client_credentials&client_id=${clientId}&client_secret=${clientSecret}"))
      .asJson
      .check(status.is(200))
      .check(jsonPath("$.access_token").saveAs("access_token"))
    )

    // 2. Do the smoke test (authenticated using the access token from (1) above)
    .exec(http("Search artifacts")
      .get(registryUrl + "/search/artifacts")
      .headers(authHeaders)
    )
  setUp(
      scn.inject(rampUsers(users) during (ramp seconds))
  ).protocols(httpProtocol)
}
