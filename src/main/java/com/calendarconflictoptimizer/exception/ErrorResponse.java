package com.calendarconflictoptimizer.exception;


import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
public class ErrorResponse {

	private int status;
	private String message;
	private long timestamp;
	private List<String> details;

	public ErrorResponse(int status, String message, long timestamp) {
		this.status = status;
		this.message = message;
		this.timestamp = timestamp;
	}

	public ErrorResponse(int status, String message, long timestamp, List<String> details) {
		this.status = status;
		this.message = message;
		this.timestamp = timestamp;
		this.details = details;
	}

}
