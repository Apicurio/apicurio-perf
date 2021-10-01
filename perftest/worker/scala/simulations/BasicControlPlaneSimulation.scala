package simulations


import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import io.apicurio.perf.refresh.TokenRefresh
import java.util.concurrent.atomic.AtomicInteger

class BasicControlPlaneSimulation extends Simulation {

  // Offline token used to acquire a JWT suitable for interacting with srs-fleet-manager API
  val ocmPath = scala.util.Properties.envOrElse("OCM_PATH", "ocm")
  val ocmUrl = scala.util.Properties.envOrElse("OCM_URL", "staging")
  val offlineToken = scala.util.Properties.envOrElse("OFFLINE_TOKEN", "")

  // Fleet manager API
  val fleetManagerUrl = scala.util.Properties.envOrElse("FLEET_MANAGER_URL", "https://api.stage.openshift.com/api/serviceregistry_mgmt")

  // Number of users to simulate, ramp up time, # of iterations, etc...
  val users = scala.util.Properties.envOrElse("TEST_USERS", "1").toInt
  val ramp = scala.util.Properties.envOrElse("TEST_RAMP_TIME", "1").toInt
  val iterations = scala.util.Properties.envOrElse("TEST_ITERATIONS", "5").toInt

  // HTTP protocol and auth header setup
  val httpProtocol = http
    .acceptHeader("*/*")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")
  val fleetManagerAuthHeaders = Map(
    "Authorization" -> s"Bearer ${TokenRefresh.getFleetManagerToken(ocmPath, ocmUrl, offlineToken)}"
  );
  val rando = new java.security.SecureRandom()
  val counter = new AtomicInteger()

  val scn = scenario("E2E Service Registry Simulation")

    // Create a new instance of Service Registry (by calling the fleet-manager API)
    ///////////////////////////////////////////////////////////////////////////////
    .exec(http("Create registry instance")
      .post(fleetManagerUrl + "/v1/registries")
      .header("Content-Type", "application/json")
      .headers(fleetManagerAuthHeaders)
      .body(StringBody(s"""
        {
          "name": "perf-test-registry-${counter.incrementAndGet}",
          "description": "This instance is for performance testing!"
        }
      """))
      .asJson
      .check(status.is(200))
      .check(jsonPath("$.id").saveAs("instance_id"))
    )

    // Poll the Fleet Manager until the Service Registry status is "ready"
    //////////////////////////////////////////////////////////////////////
    .asLongAsDuring(session => session("instance_status").asOption[String].getOrElse("nope") != "ready", 10 seconds, "counter") (
      exec(
        http("Check instance status")
          .get(fleetManagerUrl + "/v1/registries/${instance_id}")
          .headers(fleetManagerAuthHeaders)
          .asJson
          .check(status.is(200))
          .check(jsonPath("$.status").saveAs("instance_status"))
      )
      .pause(1)
    )

    // Get the registryUrl from the instance now that it's 'ready'
    //////////////////////////////////////////////////////////////
    .exec(http("Get instance url")
      .get(fleetManagerUrl + "/v1/registries/${instance_id}")
      .headers(fleetManagerAuthHeaders)
      .asJson
      .check(status.is(200))
      .check(jsonPath("$.registryUrl").saveAs("instance_url"))
    )

    // Delete the registry instance
    ///////////////////////////////
    .exec(http("Delete registry instance")
      .delete(fleetManagerUrl + "/v1/registries/${instance_id}")
      .headers(fleetManagerAuthHeaders)
      .asJson
      .check(status.is(204))
    )

  setUp(
      scn.inject(rampUsers(users) during (ramp seconds))
  ).protocols(httpProtocol)
}
