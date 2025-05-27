package com.calendarconflictoptimizer.dto.request;

import lombok.Data;

import java.util.List;

@Data
public class PropertyDTO {
	private Long id;
	private String title;
	private String location;
	private List<String> amenities;
	private Long ownerId;
}