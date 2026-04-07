package dev.ved.natalis.organization_service.mapper;

import dev.ved.natalis.organization_service.dto.OrganizationResponse;
import dev.ved.natalis.organization_service.entity.Organization;
import dev.ved.natalis.organization_service.requests.OrganizationRequest;
import org.springframework.stereotype.Component;

import java.time.Instant;

@Component
public class OrganizationMapper {

    public Organization toEntity(OrganizationRequest request) {
        Organization organization = new Organization();

        organization.setName(request.getName());
        organization.setType(request.getType());
        organization.setAddress(request.getAddress());
        organization.setIsActive(true);
        organization.setCreatedAt(Instant.now());

        return organization;
    }

    public OrganizationResponse toResponse(Organization organization) {
        return OrganizationResponse.builder()
                .id(organization.getId())
                .organizationId(organization.getOrganizationId())
                .name(organization.getName())
                .type(organization.getType())
                .address(organization.getAddress())
                .isActive(organization.getIsActive())
                .createdAt(organization.getCreatedAt())
                .build();
    }
}
