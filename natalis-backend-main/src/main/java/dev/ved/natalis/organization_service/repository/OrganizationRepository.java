package dev.ved.natalis.organization_service.repository;

import dev.ved.natalis.organization_service.entity.Organization;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrganizationRepository
        extends MongoRepository<Organization, String> {

    /* =========================
       CORE LOOKUPS
       ========================= */

    Optional<Organization> findByOrganizationId(String organizationId);

    Optional<Organization> findByOrganizationIdAndIsActiveTrue(String organizationId);

    boolean existsByOrganizationId(String organizationId);


    List<Organization> findByIsActiveTrue();

    Page<Organization> findByIsActiveTrue(Pageable pageable);

    List<Organization> findByNameRegexIgnoreCaseAndIsActiveTrue(String name);
}
