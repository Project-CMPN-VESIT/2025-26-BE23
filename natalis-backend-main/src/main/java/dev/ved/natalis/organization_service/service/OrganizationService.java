package dev.ved.natalis.organization_service.service;

import dev.ved.natalis.exception.ResourceNotFoundException;
import dev.ved.natalis.organization_service.entity.Organization;
import dev.ved.natalis.organization_service.mapper.OrganizationMapper;
import dev.ved.natalis.organization_service.repository.OrganizationRepository;
import dev.ved.natalis.organization_service.requests.OrganizationRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
public class OrganizationService {

    private final OrganizationRepository organizationRepository;
    private final OrganizationMapper organizationMapper;

    public Organization createOrganization(OrganizationRequest request) {

        Organization organization =
                organizationMapper.toEntity(request);

        organization.setOrganizationId(generateOrganizationId());

        return organizationRepository.save(organization);
    }

    public List<Organization> getAllActiveOrganizations() {
        return organizationRepository.findByIsActiveTrue();
    }

    public Page<Organization> getAllActiveOrganizations(Pageable pageable) {
        return organizationRepository.findByIsActiveTrue(pageable);
    }

    public Organization getByOrganizationId(String organizationId) {
        return organizationRepository
                .findByOrganizationIdAndIsActiveTrue(organizationId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Organization not found"));
    }

    public Organization updateOrganization(
            String organizationId,
            OrganizationRequest request
    ) {

        Organization organization = getByOrganizationId(organizationId);

        organization.setName(request.getName());
        organization.setType(request.getType());
        organization.setAddress(request.getAddress());

        return organizationRepository.save(organization);
    }

    public void deactivateOrganization(String organizationId) {

        Organization organization = getByOrganizationId(organizationId);
        organization.setIsActive(false);

        organizationRepository.save(organization);
    }

    public List<Organization> searchOrganizations(String name) {

        String regex = ".*" + Pattern.quote(name) + ".*";

        return organizationRepository
                .findByNameRegexIgnoreCaseAndIsActiveTrue(regex);
    }

    private String generateOrganizationId() {
        return "ORG-" +
                UUID.randomUUID()
                        .toString()
                        .substring(0, 8)
                        .toUpperCase();
    }
}
