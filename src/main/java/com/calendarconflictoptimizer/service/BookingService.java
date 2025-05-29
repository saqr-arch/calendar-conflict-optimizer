package com.calendarconflictoptimizer.service;

import com.calendarconflictoptimizer.dto.request.BookingDTO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface BookingService {
	List<BookingDTO> getAllBookings();
	BookingDTO getBookingById(Long id);
	BookingDTO createBooking(BookingDTO bookingDTO);
	BookingDTO updateBooking(Long id, BookingDTO bookingDTO);
	void deleteBooking(Long id);
}
