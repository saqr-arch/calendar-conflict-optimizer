package com.calendarconflictoptimizer.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class SecurityController {

	@GetMapping("/admin/data")
	public String adminOnly() {
		return "Admin data";
	}

	@GetMapping("/owner/data")
	public String ownerOnly() {
		return "Owner data";
	}

	@GetMapping("/user/data")
	public String userOnly() {
		return "User data";
	}

	@GetMapping("/whoami")
	public Map<String, Object> whoAmI(@AuthenticationPrincipal Jwt jwt) {
		return Map.of(
				"username", jwt.getClaimAsString("preferred_username"),
				"email", jwt.getClaimAsString("email"),
				"roles", jwt.getClaim("realm_access")
		);
	}
}
