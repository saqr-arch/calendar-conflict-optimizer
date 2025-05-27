package com.calendarconflictoptimizer.repository;

import com.calendarconflictoptimizer.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Integer> {
}
