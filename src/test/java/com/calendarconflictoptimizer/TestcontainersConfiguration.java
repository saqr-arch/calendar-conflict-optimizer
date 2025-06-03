package com.calendarconflictoptimizer;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

@TestConfiguration
public class TestcontainersConfiguration {

	// PostgreSQL container
	@Bean(destroyMethod = "stop")
	public PostgreSQLContainer<?> postgresContainer() {
		PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:17-alpine")
				.withDatabaseName("calendar-conflict-optimizer")
				.withUsername("postgres")
				.withPassword("postgres")
				.withExposedPorts(5433)
				.withReuse(true)
				.waitingFor(Wait.forListeningPort());
		postgres.start();
		return postgres;
	}

	// Redis container
	@Bean(destroyMethod = "stop")
	public GenericContainer<?> redisContainer() {
		GenericContainer<?> redis = new GenericContainer<>(DockerImageName.parse("redis:7-alpine"))
				.withExposedPorts(6379)
				.withReuse(true)
				.waitingFor(Wait.forListeningPort());
		redis.start();
		return redis;
	}

	// Keycloak container
	@Bean(destroyMethod = "stop")
	public GenericContainer<?> keycloakContainer() {
		GenericContainer<?> keycloak = new GenericContainer<>(DockerImageName.parse("quay.io/keycloak/keycloak:22.0"))
				.withExposedPorts(8080)
				.withEnv("KEYCLOAK_ADMIN", "admin")
				.withEnv("KEYCLOAK_ADMIN_PASSWORD", "admin")
				.withEnv("KC_DB", "postgres")
				.withEnv("KC_DB_URL", "jdbc:postgresql://db:5432/calendar-conflict-optimizer")
				.withEnv("KC_DB_USERNAME", "postgres")
				.withEnv("KC_DB_PASSWORD", "postgres")
				.withEnv("KC_HOSTNAME", "localhost")
				.withCommand("start-dev")
				.waitingFor(Wait.forHttp("/realms/master").forStatusCode(200));
		keycloak.start();
		return keycloak;
	}

	// Elasticsearch container
	@Bean(destroyMethod = "stop")
	public GenericContainer<?> elasticsearchContainer() {
		GenericContainer<?> elasticsearch = new GenericContainer<>(DockerImageName.parse("docker.elastic.co/elasticsearch/elasticsearch:8.12.2"))
				.withExposedPorts(9200, 9300)
				.withEnv("discovery.type", "single-node")
				.withEnv("xpack.security.enabled", "false")
				.withEnv("ES_JAVA_OPTS", "-Xms512m -Xmx512m")
				.withReuse(true)
				.waitingFor(Wait.forHttp("/").forStatusCode(200));
		elasticsearch.start();
		return elasticsearch;
	}

	// Kibana container
	@Bean(destroyMethod = "stop")
	public GenericContainer<?> kibanaContainer(GenericContainer<?> elasticsearchContainer) {
		GenericContainer<?> kibana = new GenericContainer<>(DockerImageName.parse("docker.elastic.co/kibana/kibana:8.12.2"))
				.withExposedPorts(5601)
				.withEnv("ELASTICSEARCH_HOSTS", "http://" + elasticsearchContainer.getHost() + ":" + elasticsearchContainer.getMappedPort(9200))
				.dependsOn(elasticsearchContainer)
				.waitingFor(Wait.forHttp("/").forStatusCode(200));
		kibana.start();
		return kibana;
	}
}
