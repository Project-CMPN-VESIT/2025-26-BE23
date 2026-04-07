package dev.ved.natalis.mother_service.controller;

import dev.ved.natalis.mother_service.dto.MotherResponse;
import dev.ved.natalis.mother_service.entity.Mother;
import dev.ved.natalis.mother_service.mapper.MotherMapper;
import dev.ved.natalis.mother_service.requests.MotherRequest;
import dev.ved.natalis.mother_service.service.MotherService;
import jakarta.validation.Valid;
import lombok.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("/api/v1/mothers")
@RequiredArgsConstructor
public class MotherController {

    private final MotherService motherService;
    private final MotherMapper motherMapper;

    @PostMapping
    public ResponseEntity<MotherResponse> createMother(
            @RequestParam String organizationId,
            @RequestParam String doctorId,
            @RequestParam(required = false) String userId,
            @Valid @RequestBody MotherRequest request
    ) {

        Mother mother = motherService.createMother(
                organizationId,
                doctorId,
                userId,
                request
        );

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(motherMapper.toResponse(mother));
    }

    @GetMapping("/{motherId}")
    public ResponseEntity<MotherResponse> getMotherById(
            @PathVariable String motherId,
            @RequestParam String organizationId
    ) {

        Mother mother = motherService
                .getMotherById(motherId, organizationId);

        return ResponseEntity.ok(
                motherMapper.toResponse(mother));
    }

    @GetMapping
    public ResponseEntity<List<MotherResponse>> getMothersByOrganization(
            @RequestParam String organizationId
    ) {

        List<MotherResponse> mothers =
                motherService.getActiveMothersByOrganization(organizationId)
                        .stream()
                        .map(motherMapper::toResponse)
                        .toList();

        return ResponseEntity.ok(mothers);
    }

    @GetMapping("/by-doctor")
    public ResponseEntity<List<MotherResponse>> getMothersByDoctor(
            @RequestParam String organizationId,
            @RequestParam String doctorId
    ) {

        List<MotherResponse> mothers =
                motherService.getActiveMothersByDoctor(
                                organizationId, doctorId)
                        .stream()
                        .map(motherMapper::toResponse)
                        .toList();

        return ResponseEntity.ok(mothers);
    }

    @GetMapping("/search")
    public ResponseEntity<List<MotherResponse>> searchMothers(
            @RequestParam String organizationId,
            @RequestParam String name
    ) {

        List<MotherResponse> mothers =
                motherService.searchMothersByName(organizationId, name)
                        .stream()
                        .map(motherMapper::toResponse)
                        .toList();

        return ResponseEntity.ok(mothers);
    }

    @PutMapping("/{motherId}")
    public ResponseEntity<MotherResponse> updateMother(
            @PathVariable String motherId,
            @RequestParam String organizationId,
            @Valid @RequestBody MotherRequest request
    ) {

        Mother mother = motherService.updateMother(
                motherId,
                organizationId,
                request
        );

        return ResponseEntity.ok(
                motherMapper.toResponse(mother));
    }

    @DeleteMapping("/{motherId}")
    public ResponseEntity<Void> deactivateMother(
            @PathVariable String motherId,
            @RequestParam String organizationId
    ) {

        motherService.deactivateMother(motherId, organizationId);
        return ResponseEntity.noContent().build();
    }
}
