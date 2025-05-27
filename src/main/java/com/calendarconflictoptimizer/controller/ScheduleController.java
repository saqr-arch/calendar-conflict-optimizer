package com.calendarconflictoptimizer.controller;

import com.calendarconflictoptimizer.dto.request.ScheduleRequest;
import com.calendarconflictoptimizer.dto.response.ScheduleResponse;
import com.calendarconflictoptimizer.service.ScheduleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/schedule")
public class ScheduleController {

	private final ScheduleService scheduleService;

	public ScheduleController(ScheduleService scheduleService) {
		this.scheduleService = scheduleService;
	}

	@PostMapping("/analyze")
	public ResponseEntity<ScheduleResponse> analyzeSchedule(@RequestBody ScheduleRequest request) {
		ScheduleResponse response = scheduleService.analyzeSchedule(request);
		return ResponseEntity.ok(response);
	}
}