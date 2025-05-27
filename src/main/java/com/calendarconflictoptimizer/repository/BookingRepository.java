package com.calendarconflictoptimizer.repository;

import com.calendarconflictoptimizer.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;

public interface BookingRepository extends JpaRepository<Booking, Integer> {

	@Query("""
        SELECT COUNT(b) > 0 FROM Booking b
        WHERE b.property.id = :propertyId
          AND b.startDate < :endDate
          AND b.endDate > :startDate
    """)
	boolean hasOverlap(@Param("propertyId") Long propertyId,
					   @Param("startDate") LocalDate startDate,
					   @Param("endDate") LocalDate endDate);
}
