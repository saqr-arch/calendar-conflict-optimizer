package com.calendarconflictoptimizer.service.impl;

import com.calendarconflictoptimizer.dto.request.BookingDTO;
import com.calendarconflictoptimizer.mapper.BookingMapper;
import com.calendarconflictoptimizer.model.Booking;
import com.calendarconflictoptimizer.model.Property;
import com.calendarconflictoptimizer.model.User;
import com.calendarconflictoptimizer.repository.BookingRepository;
import com.calendarconflictoptimizer.repository.PropertyRepository;
import com.calendarconflictoptimizer.repository.UserRepository;
import com.calendarconflictoptimizer.service.BookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {

	private final BookingRepository bookingRepository;
	private final PropertyRepository propertyRepository;
	private final UserRepository userRepository;

	@Override
	public List<BookingDTO> getAllBookings() {
		return bookingRepository.findAll().stream()
				.map(BookingMapper.INSTANCE::toDto)
				.collect(Collectors.toList());
	}

	@Override
	public BookingDTO getBookingById(Long id) {
		return bookingRepository.findById(Math.toIntExact(id))
				.map(BookingMapper.INSTANCE::toDto)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Booking not found"));
	}

	@Override
	public BookingDTO createBooking(BookingDTO dto) {
		boolean conflict = bookingRepository.hasOverlap(dto.getPropertyId(), dto.getStartDate(), dto.getEndDate());
		if (conflict) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Booking dates overlap");
		}

		Property property = propertyRepository.findById(Math.toIntExact(dto.getPropertyId()))
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Property not found"));

		User user = userRepository.findById(Math.toIntExact(dto.getUserId()))
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "User not found"));

		Booking booking = BookingMapper.INSTANCE.toEntity(dto);
		booking.setUser(user);
		booking.setProperty(property);

		Booking saved = bookingRepository.save(booking);
		return BookingMapper.INSTANCE.toDto(saved);
	}

	@Override
	public BookingDTO updateBooking(Long id, BookingDTO dto) {
		return bookingRepository.findById(Math.toIntExact(id))
				.map(existing -> {
					boolean conflict = bookingRepository.hasOverlap(dto.getPropertyId(), dto.getStartDate(), dto.getEndDate());
					if (conflict && !existing.getStartDate().equals(dto.getStartDate())) {
						throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Updated booking dates overlap");
					}

					Booking updated = BookingMapper.INSTANCE.toEntity(dto);
					updated.setId(id);
					updated.setUser(userRepository.getReferenceById(Math.toIntExact(dto.getUserId())));
					updated.setProperty(propertyRepository.getReferenceById(Math.toIntExact(dto.getPropertyId())));

					Booking saved = bookingRepository.save(updated);
					return BookingMapper.INSTANCE.toDto(saved);
				})
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Booking not found"));
	}

	@Override
	public void deleteBooking(Long id) {
		if (!bookingRepository.existsById(Math.toIntExact(id))) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Booking not found");
		}
		bookingRepository.deleteById(Math.toIntExact(id));
	}
}
