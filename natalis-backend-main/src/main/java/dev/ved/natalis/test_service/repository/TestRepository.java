package dev.ved.natalis.test_service.repository;

import dev.ved.natalis.test_service.entity.Test;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Repository
public interface TestRepository extends MongoRepository<Test, String> {

    /* =========================
       CORE LOOKUPS
       ========================= */

    Optional<Test> findByIdAndOrganizationId(String id, String organizationId);

    /// /// finding for dashboard data
    long countByOrganizationIdAndCreatedAtBetween(
            String organizationId,
            Instant start,
            Instant end
    );

    /* =========================
       MOTHER TEST HISTORY
       ========================= */

    List<Test> findByOrganizationIdAndMotherIdAndIsActiveTrueOrderByTestTimeDesc(
            String organizationId,
            String motherId
    );

    /* =========================
       DOCTOR DASHBOARD
       ========================= */

    List<Test> findByOrganizationIdAndDoctorIdAndIsActiveTrueOrderByTestTimeDesc(
            String organizationId,
            String doctorId
    );

    Page<Test> findByOrganizationId(String organizationId, Pageable pageable);


    /* =========================
       ORGANIZATION ANALYTICS
       ========================= */

    long countByOrganizationId(String organizationId);

    long countByOrganizationIdAndClassificationAndIsActiveTrue(
            String organizationId,
            String classification
    );

    Optional<Test> findTopByOrganizationIdAndMotherIdAndIsActiveTrueOrderByTestTimeDesc(
            String organizationId,
            String motherId
    );

//    List<Test> findByOrganizationIdAndVisitIdAndIsActiveTrueOrderByTestTimeDesc(
//            String organizationId,
//            String visitId
//    );

}
