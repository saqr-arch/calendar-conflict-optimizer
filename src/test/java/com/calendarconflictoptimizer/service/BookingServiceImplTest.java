package com.calendarconflictoptimizer.service;


import com.calendarconflictoptimizer.dto.request.BookingDTO;
import com.calendarconflictoptimizer.mapper.BookingMapper;
import com.calendarconflictoptimizer.model.Booking;
import com.calendarconflictoptimizer.model.Property;
import com.calendarconflictoptimizer.model.User;
import com.calendarconflictoptimizer.repository.BookingRepository;
import com.calendarconflictoptimizer.repository.PropertyRepository;
import com.calendarconflictoptimizer.repository.UserRepository;
import com.calendarconflictoptimizer.service.impl.BookingServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

class BookingServiceImplTest {

	@Mock
	private BookingRepository bookingRepository;

	@Mock
	private PropertyRepository propertyRepository;

	@Mock
	private UserRepository userRepository;

	@InjectMocks
	private BookingServiceImpl bookingService;

	private Booking booking;
	private BookingDTO bookingDTO;
	private Property property;
	private User user;

	@BeforeEach
	void setUp() {
		MockitoAnnotations.openMocks(this);

		bookingDTO = new BookingDTO();
		bookingDTO.setId(1L);
		bookingDTO.setPropertyId(1L);
		bookingDTO.setUserId(1L);
		bookingDTO.setStartDate(LocalDate.now());
		bookingDTO.setEndDate(LocalDate.now().plusDays(2));

		booking = BookingMapper.INSTANCE.toEntity(bookingDTO);

		property = new Property();
		property.setId(1L);

		user = new User();
		user.setId(1L);
	}

	@Test
	void testGetAllBookings() {
		when(bookingRepository.findAll()).thenReturn(List.of(booking));
		List<BookingDTO> bookings = bookingService.getAllBookings();
		assertThat(bookings).hasSize(1);
		verify(bookingRepository).findAll();
	}

	@Test
	void testGetBookingByIdFound() {
		when(bookingRepository.findById(1)).thenReturn(Optional.of(booking));
		BookingDTO found = bookingService.getBookingById(1L);
		assertThat(found).isNotNull();
		verify(bookingRepository).findById(1);
	}

	@Test
	void testGetBookingByIdNotFound() {
		when(bookingRepository.findById(1)).thenReturn(Optional.empty());
		assertThatThrownBy(() -> bookingService.getBookingById(1L))
				.isInstanceOf(ResponseStatusException.class);
	}

	@Test
	void testCreateBookingSuccess() {
		when(bookingRepository.hasOverlap(anyLong(), any(), any())).thenReturn(false);
		when(propertyRepository.findById(1)).thenReturn(Optional.of(property));
		when(userRepository.findById(1)).thenReturn(Optional.of(user));
		when(bookingRepository.save(any())).thenReturn(booking);

		BookingDTO created = bookingService.createBooking(bookingDTO);
		assertThat(created).isNotNull();
		verify(bookingRepository).save(any());
	}

	@Test
	void testCreateBookingConflict() {
		when(bookingRepository.hasOverlap(anyLong(), any(), any())).thenReturn(true);
		assertThatThrownBy(() -> bookingService.createBooking(bookingDTO))
				.isInstanceOf(ResponseStatusException.class)
				.hasMessageContaining("Booking dates overlap");
	}

	@Test
	void testCreateBookingMissingProperty() {
		when(bookingRepository.hasOverlap(anyLong(), any(), any())).thenReturn(false);
		when(propertyRepository.findById(1)).thenReturn(Optional.empty());

		assertThatThrownBy(() -> bookingService.createBooking(bookingDTO))
				.isInstanceOf(ResponseStatusException.class)
				.hasMessageContaining("Property not found");
	}

	@Test
	void testCreateBookingMissingUser() {
		when(bookingRepository.hasOverlap(anyLong(), any(), any())).thenReturn(false);
		when(propertyRepository.findById(1)).thenReturn(Optional.of(property));
		when(userRepository.findById(1)).thenReturn(Optional.empty());

		assertThatThrownBy(() -> bookingService.createBooking(bookingDTO))
				.isInstanceOf(ResponseStatusException.class)
				.hasMessageContaining("User not found");
	}

	@Test
	void testUpdateBookingSuccess() {
		when(bookingRepository.findById(1)).thenReturn(Optional.of(booking));
		when(bookingRepository.hasOverlap(anyLong(), any(), any())).thenReturn(false);
		when(userRepository.getReferenceById(1)).thenReturn(user);
		when(propertyRepository.getReferenceById(1)).thenReturn(property);
		when(bookingRepository.save(any())).thenReturn(booking);

		BookingDTO updated = bookingService.updateBooking(1L, bookingDTO);
		assertThat(updated).isNotNull();
	}

	@Test
	void testUpdateBookingNotFound() {
		when(bookingRepository.findById(1)).thenReturn(Optional.empty());

		assertThatThrownBy(() -> bookingService.updateBooking(1L, bookingDTO))
				.isInstanceOf(ResponseStatusException.class)
				.hasMessageContaining("Booking not found");
	}

	@Test
	void testUpdateBookingConflict() {
		when(bookingRepository.findById(1)).thenReturn(Optional.of(booking));
		when(bookingRepository.hasOverlap(anyLong(), any(), any())).thenReturn(true);

		bookingDTO.setStartDate(booking.getStartDate().plusDays(1)); // change to simulate conflict

		assertThatThrownBy(() -> bookingService.updateBooking(1L, bookingDTO))
				.isInstanceOf(ResponseStatusException.class)
				.hasMessageContaining("Updated booking dates overlap");
	}

	@Test
	void testDeleteBookingSuccess() {
		when(bookingRepository.existsById(1)).thenReturn(true);
		doNothing().when(bookingRepository).deleteById(1);

		bookingService.deleteBooking(1L);
		verify(bookingRepository).deleteById(1);
	}

	@Test
	void testDeleteBookingNotFound() {
		when(bookingRepository.existsById(1)).thenReturn(false);

		assertThatThrownBy(() -> bookingService.deleteBooking(1L))
				.isInstanceOf(ResponseStatusException.class)
				.hasMessageContaining("Booking not found");
	}
}
