package com.calendarconflictoptimizer.dto.response;

import lombok.Data;

@Data
public class Conflicts {

	private String event1;
	private String event2;
	private String overlapStart;
	private String overlapEnd;
}
