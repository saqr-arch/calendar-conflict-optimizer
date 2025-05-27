package com.calendarconflictoptimizer.mapper;

import com.calendarconflictoptimizer.dto.request.PropertyDTO;
import com.calendarconflictoptimizer.model.Property;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Mapper
public interface PropertyMapper {
	PropertyMapper INSTANCE = Mappers.getMapper(PropertyMapper.class);

	@Mapping(source = "owner.id", target = "ownerId")
	@Mapping(source = "amenities", target = "amenities", qualifiedByName = "stringToList")
	PropertyDTO toDto(Property property);

	@Mapping(source = "ownerId", target = "owner.id")
	@Mapping(source = "amenities", target = "amenities", qualifiedByName = "listToString")
	Property toEntity(PropertyDTO propertyDTO);

	@Named("stringToList")
	static List<String> stringToList(String amenities) {
		return (amenities != null && !amenities.isEmpty())
				? Arrays.asList(amenities.split(","))
				: Collections.emptyList();
	}

	@Named("listToString")
	static String listToString(List<String> amenities) {
		return (amenities != null && !amenities.isEmpty())
				? String.join(",", amenities)
				: "";
	}

	default Page<PropertyDTO> toDtoPage(Page<Property> properties) {
		return new PageImpl<>(
				properties.getContent().stream()
						.map(this::toDto)
						.toList(),
				properties.getPageable(),
				properties.getTotalElements()
		);
	}

}
