package com.calendarconflictoptimizer.service;

import com.calendarconflictoptimizer.dto.request.PropertyDTO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PropertyService {

	List<PropertyDTO> getAllProperties();

	PropertyDTO getPropertyById(Long id);

	PropertyDTO createProperty(PropertyDTO propertyDTO);

	PropertyDTO updateProperty(Long id, PropertyDTO propertyDTO);

	void deleteProperty(Long id);

	Page<PropertyDTO> searchProperties(
			Optional<String> location,
			Optional<LocalDate> startDate,
			Optional<LocalDate> endDate,
			Optional<String> amenities,
			Pageable pageable);
}
