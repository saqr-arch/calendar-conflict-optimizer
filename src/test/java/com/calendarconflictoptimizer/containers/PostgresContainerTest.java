package com.calendarconflictoptimizer.containers;

import com.calendarconflictoptimizer.TestcontainersConfiguration;
import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import static org.junit.jupiter.api.Assertions.*;

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
}


