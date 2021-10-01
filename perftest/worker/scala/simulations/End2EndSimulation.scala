package simulations


import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._
import io.apicurio.perf.refresh.TokenRefresh
import java.util.concurrent.atomic.AtomicInteger

class End2EndSimulation extends Simulation {

  // Offline token used to acquire a JWT suitable for interacting with srs-fleet-manager API
  val ocmPath = scala.util.Properties.envOrElse("OCM_PATH", "ocm")
  val ocmUrl = scala.util.Properties.envOrElse("OCM_URL", "staging")
  val offlineToken = scala.util.Properties.envOrElse("OFFLINE_TOKEN", "")

  // Token URL for MAS-SSO
  val tokenUrl = scala.util.Properties.envOrElse("TOKEN_URL", "")

  // Credentials for PerfTest service account (registry instance Admin user)
  val adminClientId = scala.util.Properties.envOrElse("ADMIN_CLIENT_ID", "")
  val adminClientSecret = scala.util.Properties.envOrElse("ADMIN_CLIENT_SECRET", "")

  // Credentials for Standard service account (registry instance Dev user)
  val devClientId = scala.util.Properties.envOrElse("DEV_CLIENT_ID", "")
  val devClientSecret = scala.util.Properties.envOrElse("DEV_CLIENT_SECRET", "")

  // Fleet manager API
  val fleetManagerUrl = scala.util.Properties.envOrElse("FLEET_MANAGER_URL", "https://api.stage.openshift.com/api/serviceregistry_mgmt")

  // Number of users to simulate, ramp up time, # of iterations, etc...
  val users = scala.util.Properties.envOrElse("TEST_USERS", "1").toInt
  val ramp = scala.util.Properties.envOrElse("TEST_RAMP_TIME", "1").toInt
  val iterations = scala.util.Properties.envOrElse("TEST_ITERATIONS", "5").toInt


  // Some useful variables.
  val rando = new java.security.SecureRandom()
  val counter = new AtomicInteger()


  // HTTP protocol and auth header setup
  val httpProtocol = http
    .acceptHeader("*/*")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

  val fleetManagerAuthHeaders = Map(
    "Authorization" -> "Bearer ${fm_auth_token}"
  )
  val adminUserAuthHeaders = Map(
    "Authorization" -> "Bearer ${admin_auth_token}"
  )
  val devUserAuthHeaders = Map(
    "Authorization" -> "Bearer ${dev_auth_token}"
  )


  // Now create the scenario
  val scn = scenario("E2E Service Registry Simulation")

    // Create a new instance of Service Registry (by calling the fleet-manager API)
    ///////////////////////////////////////////////////////////////////////////////
    .exec(session => session.set("registry_idx", "" + (counter.incrementAndGet)))
    .exec(session => session.set("fm_auth_token", TokenRefresh.getFleetManagerToken(ocmPath, ocmUrl, offlineToken)))
    .exec(http("Create registry instance")
      .post(fleetManagerUrl + "/v1/registries")
      .header("Content-Type", "application/json")
      .headers(fleetManagerAuthHeaders)
      .body(
        StringBody("""
            {
              "name": "perf-test-registry-${registry_idx}",
              "description": "This instance is for performance testing!"
            }
          """)
      )
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

    // Determine the principalId of the Registry API service account
    ////////////////////////////////////////////////////////////////
    .exec(session => session.set("dev_auth_token", TokenRefresh.getSsoToken(tokenUrl, devClientId, devClientSecret)))
    .exec(http("Get Developer principalId")
      .get("${instance_url}/apis/registry/v2/users/me")
      .headers(devUserAuthHeaders)
      .asJson
      .check(status.is(200))
      .check(jsonPath("$.username").saveAs("dev_principal_id"))
    )

    // Use access token from Admin user/svc account to grant Developer role to Registry API service account
    ////////////////////////////////////////////////////////////////////////////////////
    .exec(session => session.set("admin_auth_token", TokenRefresh.getSsoToken(tokenUrl, adminClientId, adminClientSecret)))
    .exec(http("Grant access to Developer principalId")
      .post("${instance_url}/apis/registry/v2/admin/roleMappings")
      .headers(adminUserAuthHeaders)
      .body(StringBody("""
        {
          "principalId": "${dev_principal_id}",
          "role": "DEVELOPER"
        }
      """))
      .asJson
      .check(status.is(204))
    )

    // Create artifact in registry instance
    ///////////////////////////////////////
    .exec(session => session.set("idx", "" + (rando.nextInt(users * 2) + 100)))
    .exec(http("Create artifact")
        .post("${instance_url}/apis/registry/v2/groups/default/artifacts")
        .headers(devUserAuthHeaders)
        .header("X-Registry-ArtifactId", "End2EndSimulation-${idx}")
        .queryParam("ifExists", "RETURN")
        .body(StringBody("{ \"openapi\": \"3.0.2\", \"info\": { \"title\": \"Test Artifact ${idx}\"  } }"))
        .check(jsonPath("$.globalId").saveAs("globalId"))
        .check(jsonPath("$.contentId").saveAs("contentId"))
        .check(jsonPath("$.id").saveAs("artifactId"))
    )

    // Search for artifacts in registry instance
    ////////////////////////////////////////////
    .exec(http("Search artifacts")
        .get("${instance_url}/apis/registry/v2/search/artifacts")
        .headers(devUserAuthHeaders)
        .check(status.is(200))
    )

    // Fetch artifact created above N times
    ////////////////////////////////////////
    .repeat(iterations)(
        exec(session => session.set("dev_auth_token", TokenRefresh.getSsoToken(tokenUrl, devClientId, devClientSecret)))
        .exec(http("Get artifact by ID")
          .get("${instance_url}/apis/registry/v2/ids/globalIds/${globalId}")
          .headers(devUserAuthHeaders)
        )
        .pause(500 milliseconds)
    )

    // Delete the registry instance
    ///////////////////////////////
    .exec(session => session.set("fm_auth_token", TokenRefresh.getFleetManagerToken(ocmPath, ocmUrl, offlineToken)))
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
