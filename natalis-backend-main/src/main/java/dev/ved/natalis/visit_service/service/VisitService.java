package dev.ved.natalis.visit_service.service;

import dev.ved.natalis.visit_service.entity.Visit;
import dev.ved.natalis.visit_service.repository.VisitRepository;
import dev.ved.natalis.visit_service.requests.VisitRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
public class VisitService {

    private final VisitRepository visitRepository;

    /* =========================
       CREATE VISIT
       ========================= */

    public Visit createVisit(
            String organizationId,
            VisitRequest request
    ) {
        Visit visit = new Visit();

        /* --- Relationships --- */
        visit.setOrganizationId(organizationId);
        visit.setMotherId(request.getMotherId());
        visit.setDoctorId(request.getDoctorId());

        /* --- Visit metadata --- */
        visit.setVisitDateTime(Instant.now());
        visit.setVisitType(request.getVisitType());
        visit.setReasonForVisit(request.getReasonForVisit());
        visit.setNotes(request.getNotes());

        /* --- Vitals --- */
        visit.setVitals(request.getVitals());

        /* --- Pregnancy snapshot --- */
        visit.setGestationalAgeWeeks(request.getGestationalAgeWeeks());
        visit.setTrimester(request.getTrimester());
        visit.setHighRiskAtVisit(
                request.getHighRiskAtVisit() != null
                        ? request.getHighRiskAtVisit()
                        : false
        );

        /* --- Extra notes --- */
        visit.setAdditionalNotes(request.getAdditionalNotes());

        /* --- System fields --- */
        visit.setIsActive(true);
        visit.setCreatedAt(Instant.now());
        visit.setUpdatedAt(Instant.now());

        return visitRepository.save(visit);
    }

    /* =========================
       GET VISIT
       ========================= */

    public Visit getVisitById(
            String visitId,
            String organizationId
    ) {
        return visitRepository
                .findByIdAndOrganizationId(visitId, organizationId)
                .orElseThrow(() ->
                        new NoSuchElementException("Visit not found")
                );
    }

    /* =========================
       LIST VISITS
       ========================= */

    public List<Visit> getVisitsByMother(
            String organizationId,
            String motherId
    ) {
        return visitRepository
                .findByOrganizationIdAndMotherIdAndIsActiveTrueOrderByVisitDateTimeDesc(
                        organizationId, motherId
                );
    }

    public List<Visit> getVisitsByDoctor(
            String organizationId,
            String doctorId
    ) {
        return visitRepository
                .findByOrganizationIdAndDoctorIdAndIsActiveTrueOrderByVisitDateTimeDesc(
                        organizationId, doctorId
                );
    }

    public List<Visit> getVisitsByDateRange(
            String organizationId,
            Instant start,
            Instant end
    ) {
        return visitRepository
                .findByOrganizationIdAndVisitDateTimeBetweenAndIsActiveTrue(
                        organizationId, start, end
                );
    }

    /* =========================
       UPDATE VISIT
       ========================= */

    public Visit updateVisit(
            String visitId,
            String organizationId,
            VisitRequest request
    ) {
        Visit visit = getVisitById(visitId, organizationId);

        visit.setVisitType(request.getVisitType());
        visit.setReasonForVisit(request.getReasonForVisit());
        visit.setNotes(request.getNotes());
        visit.setVitals(request.getVitals());
        visit.setGestationalAgeWeeks(request.getGestationalAgeWeeks());
        visit.setTrimester(request.getTrimester());
        visit.setHighRiskAtVisit(request.getHighRiskAtVisit());
        visit.setAdditionalNotes(request.getAdditionalNotes());

        visit.setUpdatedAt(Instant.now());

        return visitRepository.save(visit);
    }

    /* =========================
       SOFT DELETE
       ========================= */

    public void deactivateVisit(
            String visitId,
            String organizationId
    ) {
        Visit visit = getVisitById(visitId, organizationId);
        visit.setIsActive(false);
        visit.setUpdatedAt(Instant.now());
        visitRepository.save(visit);
    }
}
