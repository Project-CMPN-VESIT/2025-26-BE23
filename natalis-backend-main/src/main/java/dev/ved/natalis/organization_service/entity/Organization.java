package dev.ved.natalis.organization_service.entity;

import dev.ved.natalis.organization_service.enums.OrganizationType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "organizations")
@CompoundIndex(def = "{'organizationId': 1}", unique = true)
public class Organization {

    @Id
    private String id;   // Mongo _id

    private String organizationId; // Business ID (e.g. ORG-001)

    private String name;

    private OrganizationType type; // HOSPITAL, CLINIC, LAB

    private Address address;

    private Boolean isActive = true;

    private Instant createdAt;
}
