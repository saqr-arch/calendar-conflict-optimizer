package com.calendarconflictoptimizer.containers;

import com.calendarconflictoptimizer.TestcontainersConfiguration;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;


class PostgresContainerTest extends TestcontainersConfiguration {

	@Test
	void testConnection() throws Exception {
		String jdbcUrl = TestcontainersConfiguration.postgresContainer.getJdbcUrl();
		String username = TestcontainersConfiguration.postgresContainer.getUsername();
		String password = TestcontainersConfiguration.postgresContainer.getPassword();

		System.out.println("Connecting to DB: " + jdbcUrl);

		try (Connection connection = DriverManager.getConnection(jdbcUrl, username, password)) {
			assertNotNull(connection, "Connection should not be null");

			DatabaseMetaData metaData = connection.getMetaData();
			System.out.println("Connected to: " + metaData.getDatabaseProductName() +
					" v" + metaData.getDatabaseProductVersion());

			try (Statement stmt = connection.createStatement()) {
				try (ResultSet rs = stmt.executeQuery("SELECT 1")) {
					assertTrue(rs.next(), "Should return a row");
					assertEquals(1, rs.getInt(1), "Result should be 1");
				}
			}
		} catch (Exception ex) {
			System.err.println("Database connection test failed: " + ex.getMessage());
			throw ex;
		}
	}


	@Test
	void testRedisConnection() throws Exception {
		String host = redisContainer.getHost();
		int port = redisContainer.getMappedPort(6379);

		try (Socket socket = new Socket(host, port)) {
			assertTrue(socket.isConnected(), "Redis should be reachable");
		}
	}

	@Test
	void testElasticsearchConnection() throws Exception {
		String esUrl = System.getProperty("ELASTICSEARCH_HOST");
		assertNotNull(esUrl, "Elasticsearch URL should be set");

		URL url = new URL(esUrl);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setRequestMethod("GET");
		connection.setConnectTimeout(5000);
		connection.setReadTimeout(5000);

		int responseCode = connection.getResponseCode();
		assertTrue(responseCode == 200 || responseCode == 401, "Elasticsearch should respond (HTTP 200 or 401), got: " + responseCode);
	}

	@Test
	void testKeycloakConnection() throws IOException {
		String keycloakUrl = System.getProperty("KEYCLOAK_URL");
		assertNotNull(keycloakUrl, "Keycloak URL should be set");

		URL url = new URL(keycloakUrl + "/realms/master");
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		System.out.println("Testing Keycloak URL: " + keycloakUrl);
		connection.setRequestMethod("GET");
		connection.setConnectTimeout(5000);
		connection.setReadTimeout(5000);

		int responseCode = connection.getResponseCode();
		assertTrue(responseCode == 200 || responseCode == 404, "Keycloak should be reachable, got: " + responseCode);
	}
}


