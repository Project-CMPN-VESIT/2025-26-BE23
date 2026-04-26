package dev.ved.natalis.visit_service.repository;

import dev.ved.natalis.visit_service.entity.Visit;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Repository
public interface VisitRepository extends MongoRepository<Visit, String> {

    Optional<Visit> findByIdAndOrganizationId(String id, String organizationId);

    List<Visit> findByOrganizationIdAndMotherIdAndIsActiveTrueOrderByVisitDateTimeDesc(
            String organizationId,
             String motherId
    );

    List<Visit> findByOrganizationIdAndDoctorIdAndIsActiveTrueOrderByVisitDateTimeDesc(
            String organizationId,
             String doctorId
    );

    List<Visit> findByOrganizationIdAndVisitDateTimeBetweenAndIsActiveTrue(
            String organizationId,
            Instant start,
            Instant end
    );
}
