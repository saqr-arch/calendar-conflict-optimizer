package com.calendarconflictoptimizer.repository;

import com.calendarconflictoptimizer.model.Property;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;


public interface PropertyRepository extends JpaRepository<Property, Integer> {
	Page<Property> findAll(Specification<Property> spec, Pageable pageable);
}
