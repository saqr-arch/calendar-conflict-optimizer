package com.calendarconflictoptimizer.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.SecurityFilterChain;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http
				.authorizeHttpRequests(auth -> auth
						.requestMatchers("/api/admin/**").hasRole("admin")
						.requestMatchers("/api/owner/**").hasRole("owner")
						.requestMatchers("/api/user/**").hasRole("user")
						.requestMatchers("/api/whoami").authenticated()
						.anyRequest().permitAll()
				)
				.oauth2ResourceServer(oauth2 -> oauth2
						.jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter()))
				);
		return http.build();
	}


	@Bean
	public JwtAuthenticationConverter jwtAuthenticationConverter() {
		JwtAuthenticationConverter converter = new JwtAuthenticationConverter();

		converter.setJwtGrantedAuthoritiesConverter(jwt -> {
			Object realmAccessObj = jwt.getClaims().get("realm_access");

			if (!(realmAccessObj instanceof Map<?, ?> realmAccess)) {
				return List.of();
			}

			Object rolesObj = realmAccess.get("roles");
			if (!(rolesObj instanceof List<?> rolesList)) {
				return List.of();
			}

			return rolesList.stream()
					.filter(String.class::isInstance)
					.map(role -> new SimpleGrantedAuthority("ROLE_" + (String) role))
					.collect(Collectors.toList());

		});

		return converter;
	}


}
