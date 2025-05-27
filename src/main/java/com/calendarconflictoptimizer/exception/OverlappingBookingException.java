package com.calendarconflictoptimizer.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.CONFLICT)
public class OverlappingBookingException extends RuntimeException {
	public OverlappingBookingException() {
		super();
	}

	public OverlappingBookingException(String message) {
		super(message);
	}

	public OverlappingBookingException(String message, Throwable cause) {
		super(message, cause);
	}

	public OverlappingBookingException(Throwable cause) {
		super(cause);
	}
}
