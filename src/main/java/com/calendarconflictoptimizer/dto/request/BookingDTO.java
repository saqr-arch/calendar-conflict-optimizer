package com.calendarconflictoptimizer.dto.request;

import lombok.Data;

import java.time.LocalDate;

@Data
public class BookingDTO {
	private Long id;
	private Long propertyId;
	private Long userId;
	private LocalDate startDate;
	private LocalDate endDate;
}
