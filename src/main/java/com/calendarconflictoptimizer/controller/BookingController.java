package com.calendarconflictoptimizer.controller;

import com.calendarconflictoptimizer.dto.request.BookingDTO;
import com.calendarconflictoptimizer.service.BookingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class BookingController {

	private final BookingService bookingService;

	@GetMapping
	public List<BookingDTO> getAll() {
		return bookingService.getAllBookings();
	}

	@GetMapping("/{id}")
	public ResponseEntity<BookingDTO> getById(@PathVariable Long id) {
		return ResponseEntity.ok(bookingService.getBookingById(id));
	}

	@PostMapping
	public ResponseEntity<BookingDTO> create(@Valid @RequestBody BookingDTO dto) {
		BookingDTO created = bookingService.createBooking(dto);
		return ResponseEntity.status(201).body(created);
	}

	@PutMapping("/{id}")
	public ResponseEntity<BookingDTO> update(@PathVariable Long id, @Valid @RequestBody BookingDTO dto) {
		BookingDTO updated = bookingService.updateBooking(id, dto);
		return ResponseEntity.ok(updated);
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		bookingService.deleteBooking(id);
		return ResponseEntity.noContent().build();
	}
}
