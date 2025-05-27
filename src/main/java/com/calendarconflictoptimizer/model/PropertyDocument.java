package com.calendarconflictoptimizer.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Data
@Document(indexName = "property-index")
public class PropertyDocument {
	@Id
	private String id;
	private String title;
	private String location;
	private String amenities;
}
