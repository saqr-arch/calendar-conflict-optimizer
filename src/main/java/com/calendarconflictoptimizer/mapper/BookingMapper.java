package com.calendarconflictoptimizer.mapper;

import com.calendarconflictoptimizer.dto.request.BookingDTO;
import com.calendarconflictoptimizer.model.Booking;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper
public interface BookingMapper {
	BookingMapper INSTANCE = Mappers.getMapper(BookingMapper.class);

	@Mapping(source = "user.id", target = "userId")
	@Mapping(source = "property.id", target = "propertyId")
	BookingDTO toDto(Booking booking);

	@Mapping(source = "userId", target = "user.id")
	@Mapping(source = "propertyId", target = "property.id")
	Booking toEntity(BookingDTO bookingDTO);
}
