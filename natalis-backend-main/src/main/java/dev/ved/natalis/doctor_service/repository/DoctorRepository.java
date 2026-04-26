package dev.ved.natalis.doctor_service.repository;
import dev.ved.natalis.doctor_service.entity.Doctor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DoctorRepository extends MongoRepository<Doctor, String> {

    Optional<Doctor> findByUserId(String userId);

    boolean existsByUserId(String userId);

    Optional<Doctor> findByIdAndOrganizationId(String id, String organizationId);

    List<Doctor> findByOrganizationIdAndIsActiveTrue(String organizationId);

    Page<Doctor> findByOrganizationIdAndIsActiveTrue(
            String organizationId,
            Pageable pageable
    );

    List<Doctor> findByOrganizationIdAndNameRegexIgnoreCaseAndIsActiveTrue(
            String organizationId,
            String name
    );

    List<Doctor> findByOrganizationIdAndSpecializationAndIsActiveTrue(
            String organizationId,
            String specialization
    );

    long countByOrganizationIdAndIsActiveTrue(String organizationId);
}
