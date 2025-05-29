package com.calendarconflictoptimizer.repository;


import com.calendarconflictoptimizer.model.PropertyDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import java.util.List;

public interface PropertySearchRepository extends ElasticsearchRepository<PropertyDocument, String> {
	List<PropertyDocument> findByLocation(String location);
}