package dev.ved.natalis.visit_service.controller;


import dev.ved.natalis.visit_service.dto.VisitResponse;
import dev.ved.natalis.visit_service.entity.Visit;
import dev.ved.natalis.visit_service.requests.VisitRequest;
import dev.ved.natalis.visit_service.service.VisitService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.util.List;

@RestController
@RequestMapping("/api/v1/visits")
@RequiredArgsConstructor
public class VisitController {

    private final VisitService visitService;

    /* =========================
       CREATE VISIT
       ========================= */

    @PostMapping
    public ResponseEntity<VisitResponse> createVisit(
            @RequestParam String organizationId,
            @Valid @RequestBody VisitRequest request
    ) {
        Visit visit = visitService.createVisit(organizationId, request);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(mapToResponse(visit));
    }

    /* =========================
       GET VISIT BY ID
       ========================= */

    @GetMapping("/{visitId}")
    public ResponseEntity<VisitResponse> getVisitById(
            @PathVariable String visitId,
            @RequestParam String organizationId
    ) {
        Visit visit = visitService.getVisitById(visitId, organizationId);
        return ResponseEntity.ok(mapToResponse(visit));
    }

    /* =========================
       GET VISITS BY MOTHER
       ========================= */

    @GetMapping("/by-mother")
    public ResponseEntity<List<VisitResponse>> getVisitsByMother(
            @RequestParam String organizationId,
            @RequestParam String motherId
    ) {
        List<VisitResponse> visits = visitService
                .getVisitsByMother(organizationId, motherId)
                .stream()
                .map(this::mapToResponse)
                .toList();

        return ResponseEntity.ok(visits);
    }

    /* =========================
       GET VISITS BY DOCTOR
       ========================= */

    @GetMapping("/by-doctor")
    public ResponseEntity<List<VisitResponse>> getVisitsByDoctor(
            @RequestParam String organizationId,
            @RequestParam String doctorId
    ) {
        List<VisitResponse> visits = visitService
                .getVisitsByDoctor(organizationId, doctorId)
                .stream()
                .map(this::mapToResponse)
                .toList();

        return ResponseEntity.ok(visits);
    }

    /* =========================
       GET VISITS BY DATE RANGE
       ========================= */

    @GetMapping("/by-date")
    public ResponseEntity<List<VisitResponse>> getVisitsByDateRange(
            @RequestParam String organizationId,
            @RequestParam Instant start,
            @RequestParam Instant end
    ) {
        List<VisitResponse> visits = visitService
                .getVisitsByDateRange(organizationId, start, end)
                .stream()
                .map(this::mapToResponse)
                .toList();

        return ResponseEntity.ok(visits);
    }

    /* =========================
       UPDATE VISIT
       ========================= */

    @PutMapping("/{visitId}")
    public ResponseEntity<VisitResponse> updateVisit(
            @PathVariable String visitId,
            @RequestParam String organizationId,
            @Valid @RequestBody VisitRequest request
    ) {
        Visit visit = visitService.updateVisit(visitId, organizationId, request);
        return ResponseEntity.ok(mapToResponse(visit));
    }

    /* =========================
       DEACTIVATE VISIT
       ========================= */

    @DeleteMapping("/{visitId}")
    public ResponseEntity<Void> deactivateVisit(
            @PathVariable String visitId,
            @RequestParam String organizationId
    ) {
        visitService.deactivateVisit(visitId, organizationId);
        return ResponseEntity.noContent().build();
    }

    /* =========================
       MAPPER
       ========================= */

    private VisitResponse mapToResponse(Visit visit) {
        return VisitResponse.builder()
                .id(visit.getId())
                .organizationId(visit.getOrganizationId())
                .motherId(visit.getMotherId())
                .doctorId(visit.getDoctorId())
                .visitDateTime(visit.getVisitDateTime())
                .visitType(visit.getVisitType())
                .reasonForVisit(visit.getReasonForVisit())
                .notes(visit.getNotes())
                .vitals(visit.getVitals())
                .gestationalAgeWeeks(visit.getGestationalAgeWeeks())
                .trimester(visit.getTrimester())
                .highRiskAtVisit(visit.getHighRiskAtVisit())
                .build();
    }
}
