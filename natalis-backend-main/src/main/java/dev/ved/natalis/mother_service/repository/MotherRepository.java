package dev.ved.natalis.mother_service.repository;

import dev.ved.natalis.mother_service.entity.Mother;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MotherRepository extends MongoRepository<Mother, String> {

    /* =========================
       CORE LOOKUPS
       ========================= */

    Optional<Mother> findByIdAndOrganizationId(String id, String organizationId);

    List<Mother> findByOrganizationIdAndIsActiveTrue(String organizationId);

    /* =========================
       DOCTOR-WISE QUERIES
       ========================= */

    List<Mother> findByDoctorIdAndIsActiveTrue(String doctorId);

    List<Mother> findByOrganizationIdAndDoctorIdAndIsActiveTrue(
            String organizationId,
            String doctorId
    );

    /* =========================
       USER LINKING
       ========================= */

    Optional<Mother> findByUserId(String userId);

    boolean existsByUserId(String userId);

    /* =========================
       SEARCH
       ========================= */

    List<Mother> findByOrganizationIdAndNameRegexIgnoreCaseAndIsActiveTrue(
            String organizationId,
            String name
    );

    /* =========================
       ANALYTICS / DASHBOARD
       ========================= */

    long countByOrganizationIdAndIsActiveTrue(String organizationId);

    long countByDoctorIdAndIsActiveTrue(String doctorId);
}
