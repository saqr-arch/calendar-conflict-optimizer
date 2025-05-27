package com.calendarconflictoptimizer.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
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
		Map<String, Object> userInfo = new HashMap<>();
		userInfo.put("username", jwt.getClaimAsString("preferred_username"));
		userInfo.put("email", jwt.getClaimAsString("email"));

		Map<String, Object> realmAccess = jwt.getClaim("realm_access");
		if (realmAccess != null && realmAccess.get("roles") instanceof List) {
			userInfo.put("roles", realmAccess.get("roles"));
		} else {
			userInfo.put("roles", List.of());
		}

		return userInfo;
	}
}
