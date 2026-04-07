package dev.ved.natalis.organization_service.controller;

import dev.ved.natalis.doctor_service.service.DoctorService;
import dev.ved.natalis.organization_service.dto.OrganizationResponse;
import dev.ved.natalis.organization_service.entity.Organization;
import dev.ved.natalis.organization_service.mapper.OrganizationMapper;
import dev.ved.natalis.organization_service.requests.OrganizationRequest;
import dev.ved.natalis.organization_service.service.OrganizationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("/api/v1/organizations")
@RequiredArgsConstructor
public class OrganizationController {

    private final OrganizationService organizationService;
    private final OrganizationMapper organizationMapper;

    @PostMapping
    public ResponseEntity<OrganizationResponse> createOrganization(
            @Valid @RequestBody OrganizationRequest request
    ) {

        Organization organization =
                organizationService.createOrganization(request);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(organizationMapper.toResponse(organization));
    }

    @GetMapping
    public ResponseEntity<List<OrganizationResponse>> getAllOrganizations() {

        List<OrganizationResponse> organizations =
                organizationService.getAllActiveOrganizations()
                        .stream()
                        .map(organizationMapper::toResponse)
                        .toList();

        return ResponseEntity.ok(organizations);
    }

    @GetMapping("/paged")
    public ResponseEntity<Page<OrganizationResponse>> getOrganizationsPaged(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {

        Pageable pageable = PageRequest.of(page, size);

        Page<OrganizationResponse> response =
                organizationService.getAllActiveOrganizations(pageable)
                        .map(organizationMapper::toResponse);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/{organizationId}")
    public ResponseEntity<OrganizationResponse> getOrganizationById(
            @PathVariable String organizationId
    ) {

        Organization organization =
                organizationService.getByOrganizationId(organizationId);

        return ResponseEntity.ok(
                organizationMapper.toResponse(organization)
        );
    }

    @PutMapping("/{organizationId}")
    public ResponseEntity<OrganizationResponse> updateOrganization(
            @PathVariable String organizationId,
            @Valid @RequestBody OrganizationRequest request
    ) {

        Organization organization =
                organizationService.updateOrganization(organizationId, request);

        return ResponseEntity.ok(
                organizationMapper.toResponse(organization)
        );
    }

    @DeleteMapping("/{organizationId}")
    public ResponseEntity<Void> deactivateOrganization(
            @PathVariable String organizationId
    ) {

        organizationService.deactivateOrganization(organizationId);
        return ResponseEntity.noContent().build();
    }
}
