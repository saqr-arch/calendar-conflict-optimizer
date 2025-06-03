package com.calendarconflictoptimizer;

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


}
