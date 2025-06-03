package com.calendarconflictoptimizer;

import org.springframework.boot.SpringApplication;

public class
TestCalendarConflictOptimizerApplication {

	public static void main(String[] args) {
		SpringApplication.from(CalendarConflictOptimizerApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
