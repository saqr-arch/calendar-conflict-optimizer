package com.calendarconflictoptimizer;

import org.junit.jupiter.api.BeforeAll;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.time.Duration;

@Testcontainers
public class TestcontainersConfiguration {

	// PostgreSQL container
	@Container
	public static final PostgreSQLContainer<?> postgresContainer =
			new PostgreSQLContainer<>("postgres:17-alpine")
					.withDatabaseName("calendar-conflict-optimizer")
					.withUsername("postgres")
					.withPassword("postgres")
					.withReuse(true)
					.withExposedPorts(5432)
					.waitingFor(
							Wait.forListeningPort().withStartupTimeout(Duration.ofSeconds(60))
					);

	// Redis
	@Container
	public static final GenericContainer<?> redisContainer =
			new GenericContainer<>("redis:7-alpine")
					.withExposedPorts(6379)
					.withReuse(true);

	// Elasticsearch
	@Container
	public static final GenericContainer<?> elasticsearchContainer =
			new GenericContainer<>("docker.elastic.co/elasticsearch/elasticsearch:8.12.2")
					.withEnv("discovery.type", "single-node")
					.withEnv("xpack.security.enabled", "false")
					.withEnv("ES_JAVA_OPTS", "-Xms512m -Xmx512m")
					.withExposedPorts(9200)
					.withReuse(true);

	public static GenericContainer<?> keycloakContainer;

	static {
		// Start the containers
		postgresContainer.start();
		redisContainer.start();
		elasticsearchContainer.start();

		keycloakContainer = new GenericContainer<>("quay.io/keycloak/keycloak:22.0")
				.withExposedPorts(8081)
				.withEnv("KEYCLOAK_ADMIN", "admin")
				.withEnv("KEYCLOAK_ADMIN_PASSWORD", "admin")
				.withEnv("KC_DB", "postgres")
				.withEnv("KC_DB_URL", postgresContainer.getJdbcUrl())
				.withEnv("KC_DB_USERNAME", "postgres")
				.withEnv("KC_DB_PASSWORD", "postgres")
				.withCommand("start-dev")
				.waitingFor(Wait.forHttp("/realms/master")
						.forStatusCodeMatching(code -> code == 200 || code == 404)  // Accept 404 if realm not created yet
						.withStartupTimeout(Duration.ofSeconds(60)))
				.withReuse(true);

	}

	@BeforeAll
	public static void initSystemProperties() {
		System.setProperty("DB_URL", postgresContainer.getJdbcUrl());
		System.setProperty("DB_USERNAME", postgresContainer.getUsername());
		System.setProperty("DB_PASSWORD", postgresContainer.getPassword());

		System.setProperty("REDIS_HOST", redisContainer.getHost());
		System.setProperty("REDIS_PORT", redisContainer.getMappedPort(6379).toString());

		System.setProperty("ELASTICSEARCH_HOST", "http://" + elasticsearchContainer.getHost() + ":" + elasticsearchContainer.getMappedPort(9200));

		System.setProperty("KEYCLOAK_URL", "http://" + keycloakContainer.getHost() + ":" + 8081);
		System.setProperty("KEYCLOAK_REALM", "property-rental");
		System.setProperty("KEYCLOAK_CLIENT_ID", "property-app");
		System.setProperty("KEYCLOAK_CLIENT_SECRET", "R87X9tRk8zh6drHr9d8FO2YwI8bPfOnN");
	}


}
