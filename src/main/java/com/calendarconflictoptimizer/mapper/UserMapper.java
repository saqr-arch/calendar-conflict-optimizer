package com.calendarconflictoptimizer.mapper;

import com.calendarconflictoptimizer.dto.request.UserDTO;
import com.calendarconflictoptimizer.model.User;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface UserMapper {
	UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

	UserDTO toDto(User user);
	User toEntity(UserDTO userDTO);
}
