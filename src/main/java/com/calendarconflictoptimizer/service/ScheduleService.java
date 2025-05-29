package com.calendarconflictoptimizer.service;

import com.calendarconflictoptimizer.dto.request.Events;
import com.calendarconflictoptimizer.dto.request.ScheduleRequest;
import com.calendarconflictoptimizer.dto.response.Conflicts;
import com.calendarconflictoptimizer.dto.response.FreeSlotz;
import com.calendarconflictoptimizer.dto.response.ScheduleResponse;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Service
public class ScheduleService {
	private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
	private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ISO_OFFSET_DATE_TIME;

	public ScheduleResponse analyzeSchedule(ScheduleRequest request) {

		validateRequest(request);


		List<Events> events = request.getEvents();
		List<Conflicts> conflicts = findConflicts(events);
		List<FreeSlotz> freeSlots = findFreeSlots(request, events);


		ScheduleResponse response = new ScheduleResponse();
		response.setConflicts(conflicts);
		response.setFreeSlots(freeSlots);
		return response;
	}

	private void validateRequest(ScheduleRequest request) {
		if (request == null) {
			throw new IllegalArgumentException("Request cannot be null");
		}
		if (request.getWorkingHours() == null) {
			throw new IllegalArgumentException("Working hours must be specified");
		}
		if (request.getEvents() == null || request.getEvents().isEmpty()) {
			throw new IllegalArgumentException("At least one event must be provided");
		}
	}

	private List<Conflicts> findConflicts(List<Events> events) {
		List<Conflicts> conflicts = new ArrayList<>();


		events.sort(Comparator.comparing(e -> parseDateTime(e.getStartTime())));

		for (int i = 0; i < events.size() - 1; i++) {
			Events current = events.get(i);
			Events next = events.get(i + 1);

			ZonedDateTime currentEnd = parseDateTime(current.getEndTime());
			ZonedDateTime nextStart = parseDateTime(next.getStartTime());

			if (currentEnd.isAfter(nextStart)) {
				Conflicts conflict = new Conflicts();
				conflict.setEvent1(current.getTitle());
				conflict.setEvent2(next.getTitle());
				conflict.setOverlapStart(nextStart.format(DATE_TIME_FORMATTER));
				conflict.setOverlapEnd(currentEnd.isBefore(parseDateTime(next.getEndTime()))
						? currentEnd.format(DATE_TIME_FORMATTER)
						: parseDateTime(next.getEndTime()).format(DATE_TIME_FORMATTER));
				conflicts.add(conflict);
			}
		}

		return conflicts;
	}

	private List<FreeSlotz> findFreeSlots(ScheduleRequest request, List<Events> events) {
		List<FreeSlotz> freeSlots = new ArrayList<>();
		List<Events> sortedEvents = new ArrayList<>(events);

		sortedEvents.sort(Comparator.comparing(e -> parseDateTime(e.getStartTime())));

		LocalTime workStart = LocalTime.parse(request.getWorkingHours().getStart(), TIME_FORMATTER);
		LocalTime workEnd = LocalTime.parse(request.getWorkingHours().getEnd(), TIME_FORMATTER);

		ZonedDateTime firstEventStart = parseDateTime(sortedEvents.get(0).getStartTime());
		ZonedDateTime dayStart = firstEventStart.with(workStart);
		ZonedDateTime dayEnd = firstEventStart.with(workEnd);

		ZonedDateTime firstEvent = parseDateTime(sortedEvents.get(0).getStartTime());
		if (dayStart.isBefore(firstEvent)) {
			freeSlots.add(createFreeSlot(dayStart, firstEvent));
		}

		for (int i = 0; i < sortedEvents.size() - 1; i++) {
			ZonedDateTime currentEnd = parseDateTime(sortedEvents.get(i).getEndTime());
			ZonedDateTime nextStart = parseDateTime(sortedEvents.get(i + 1).getStartTime());

			if (currentEnd.isBefore(nextStart)) {
				freeSlots.add(createFreeSlot(currentEnd, nextStart));
			}
		}

		ZonedDateTime lastEventEnd = parseDateTime(sortedEvents.get(sortedEvents.size() - 1).getEndTime());
		if (lastEventEnd.isBefore(dayEnd)) {
			freeSlots.add(createFreeSlot(lastEventEnd, dayEnd));
		}

		return freeSlots;
	}

	private FreeSlotz createFreeSlot(ZonedDateTime start, ZonedDateTime end) {
		FreeSlotz slot = new FreeSlotz();
		slot.setStart(start.format(DATE_TIME_FORMATTER));
		slot.setEnd(end.format(DATE_TIME_FORMATTER));
		return slot;
	}

	private ZonedDateTime parseDateTime(String dateTime) {
		try {
			return ZonedDateTime.parse(dateTime, DATE_TIME_FORMATTER);
		} catch (Exception e) {
			throw new IllegalArgumentException("Invalid date-time format: " + dateTime);
		}
	}
}
