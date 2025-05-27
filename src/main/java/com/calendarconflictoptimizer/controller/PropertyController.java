package com.calendarconflictoptimizer.controller;

import com.calendarconflictoptimizer.dto.request.PropertyDTO;
import com.calendarconflictoptimizer.service.PropertyService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/properties")
@RequiredArgsConstructor
public class PropertyController {

	private final PropertyService propertyService;

	@GetMapping
	public List<PropertyDTO> getAll() {
		return propertyService.getAllProperties();
	}

	@GetMapping("/{id}")
	public ResponseEntity<PropertyDTO> getById(@PathVariable Long id) {
		return ResponseEntity.ok(propertyService.getPropertyById(id));
	}

	@PostMapping
	public ResponseEntity<PropertyDTO> create(@Valid @RequestBody PropertyDTO dto) {
		return ResponseEntity.status(201).body(propertyService.createProperty(dto));
	}

	@PutMapping("/{id}")
	public ResponseEntity<PropertyDTO> update(@PathVariable Long id, @Valid @RequestBody PropertyDTO dto) {
		return ResponseEntity.ok(propertyService.updateProperty(id, dto));
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		propertyService.deleteProperty(id);
		return ResponseEntity.noContent().build();
	}

	@GetMapping("/search")
	public Page<PropertyDTO> searchProperties(
			@RequestParam Optional<String> location,
			@RequestParam Optional<LocalDate> startDate,
			@RequestParam Optional<LocalDate> endDate,
			@RequestParam Optional<String> amenities,
			Pageable pageable
	) {
		return propertyService.searchProperties(location, startDate, endDate, amenities, pageable);
	}
}
