package com.calendarconflictoptimizer.dto.request;

import lombok.Data;

import java.util.List;

@Data
public class ScheduleRequest {

	private WorkingHours workingHours;
	private String timeZone;
	private List<Events> events;
}
