
--Find Top 5 Users by Distinct Properties Booked
SELECT u.id, u.name, COUNT(DISTINCT b.property_id) AS distinct_properties
FROM booking b
JOIN users u ON b.user_id = u.id
GROUP BY u.id, u.name
ORDER BY distinct_properties DESC
LIMIT 5;
-- Recommend Schema / Indexing Improvements for Large Datasets
-- For booking overlap checks
CREATE INDEX idx_booking_property_start_end ON booking(property_id, start_date, end_date);

-- For user bookings
CREATE INDEX idx_booking_user_property ON booking(user_id, property_id);

-- For searching properties by location
CREATE INDEX idx_property_location_lower ON property (LOWER(location));

-- For JSONB amenities (if JSONB)
CREATE INDEX idx_property_amenities_gin ON property USING GIN (amenities);

-- For normalized amenities (join table)
CREATE INDEX idx_property_amenity_property ON property_amenities(property_id);
CREATE INDEX idx_property_amenity_amenity ON property_amenities(amenity_id);


