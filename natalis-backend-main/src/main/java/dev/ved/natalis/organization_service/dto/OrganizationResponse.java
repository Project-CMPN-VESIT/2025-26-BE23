package dev.ved.natalis.organization_service.dto;

import dev.ved.natalis.organization_service.entity.Address;
import dev.ved.natalis.organization_service.enums.OrganizationType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

import java.time.Instant;

@Builder
@Getter
@AllArgsConstructor
public class OrganizationResponse {

    private String id;
    private String organizationId;
    private String name;
    private OrganizationType type;
    private Address address;
    private Boolean isActive;
    private Instant createdAt;
}
