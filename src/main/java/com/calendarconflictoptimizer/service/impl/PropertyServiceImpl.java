package com.calendarconflictoptimizer.service.impl;

import com.calendarconflictoptimizer.dto.request.PropertyDTO;
import com.calendarconflictoptimizer.mapper.PropertyMapper;
import com.calendarconflictoptimizer.model.Property;
import com.calendarconflictoptimizer.model.PropertyDocument;
import com.calendarconflictoptimizer.repository.PropertyRepository;
import com.calendarconflictoptimizer.repository.PropertySearchRepository;
import com.calendarconflictoptimizer.repository.UserRepository;
import com.calendarconflictoptimizer.service.PropertyService;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PropertyServiceImpl implements PropertyService {

	private final PropertyRepository propertyRepository;
	private final PropertySearchRepository esRepository;
	private final UserRepository userRepository;

	@Override
	public List<PropertyDTO> getAllProperties() {
		return propertyRepository.findAll().stream()
				.map(PropertyMapper.INSTANCE::toDto)
				.collect(Collectors.toList());
	}

	@Override
	public PropertyDTO getPropertyById(Long id) {
		return propertyRepository.findById(Math.toIntExact(id))
				.map(PropertyMapper.INSTANCE::toDto)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Property not found"));
	}

	@Override
	public PropertyDTO createProperty(PropertyDTO dto) {
		Property property = PropertyMapper.INSTANCE.toEntity(dto);
		property.setOwner(userRepository.getReferenceById(Math.toIntExact(dto.getOwnerId())));
		Property saved = propertyRepository.save(property);
		return PropertyMapper.INSTANCE.toDto(saved);
	}

	@Override
	public PropertyDTO updateProperty(Long id, PropertyDTO dto) {
		return propertyRepository.findById(Math.toIntExact(id))
				.map(existing -> {
					Property updated = PropertyMapper.INSTANCE.toEntity(dto);
					updated.setId(id);
					updated.setOwner(userRepository.getReferenceById(Math.toIntExact(dto.getOwnerId())));
					Property saved = propertyRepository.save(updated);
					return PropertyMapper.INSTANCE.toDto(saved);
				})
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Property not found"));
	}

	@Override
	public void deleteProperty(Long id) {
		if (!propertyRepository.existsById(Math.toIntExact(id))) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Property not found");
		}
		propertyRepository.deleteById(Math.toIntExact(id));
	}

	@Override
	public Page<PropertyDTO> searchProperties(Optional<String> location,
											  Optional<LocalDate> startDate,
											  Optional<LocalDate> endDate,
											  Optional<String> amenities,
											  Pageable pageable) {
		Specification<Property> spec = (root, query, cb) -> {
			List<Predicate> predicates = new ArrayList<>();

			location.ifPresent(loc -> predicates.add(cb.like(cb.lower(root.get("location")), "%" + loc.toLowerCase() + "%")));

			startDate.ifPresent(st -> predicates.add(cb.equal(root.get("startDate"), st)));
			endDate.ifPresent(en -> predicates.add(cb.equal(root.get("endDate"), en)));

			amenities.ifPresent(a -> predicates.add(cb.like(cb.lower(root.get("amenities")), "%" + a.toLowerCase() + "%")));

			return cb.and(predicates.toArray(new Predicate[0]));
		};

		Page<Property> propertiesPage = propertyRepository.findAll(spec, pageable);
		return PropertyMapper.INSTANCE.toDtoPage(propertiesPage);
	}



	/**
	 * Elastic Search
	 * */
	public Property save(Property property) {
		var saved = propertyRepository.save(property);

		PropertyDocument doc = new PropertyDocument();
		doc.setId(String.valueOf(saved.getId()));
		doc.setTitle(saved.getTitle());
		doc.setLocation(saved.getLocation());
		esRepository.save(doc);
		return saved;
	}

	public List<PropertyDocument> searchByLocation(String location) {
		return esRepository.findByLocation(location);
	}
}
