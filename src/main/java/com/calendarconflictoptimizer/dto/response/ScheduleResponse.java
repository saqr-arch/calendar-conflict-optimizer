package com.calendarconflictoptimizer.dto.response;

import lombok.Data;

import java.util.List;

@Data
public class ScheduleResponse {

	private List<Conflicts> conflicts;
	private List<FreeSlotz> freeSlots;
}
