package dev.ved.natalis.doctor_service.controller;

import dev.ved.natalis.doctor_service.dto.DoctorResponse;
import dev.ved.natalis.doctor_service.entity.Doctor;
import dev.ved.natalis.doctor_service.mapper.DoctorMapper;
import dev.ved.natalis.doctor_service.requests.DoctorRequest;
import dev.ved.natalis.doctor_service.service.DoctorService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
@RestController
@RequestMapping("/api/v1/doctors")
@RequiredArgsConstructor
public class DoctorController {

    private final DoctorService doctorService;
    private final DoctorMapper doctorMapper;

    @PostMapping
    public ResponseEntity<DoctorResponse> createDoctor(
            @RequestParam String userId,
            @RequestParam String organizationId,
            @RequestParam String organizationName,
            @Valid @RequestBody DoctorRequest request
    ) {

        Doctor doctor = doctorService.createDoctor(
                userId,
                organizationId,
                organizationName,
                doctorMapper.toEntity(request)
        );

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(doctorMapper.toResponse(doctor));
    }

    @GetMapping
    public ResponseEntity<List<DoctorResponse>> getDoctors(
            @RequestParam String organizationId
    ) {

        List<DoctorResponse> doctors = doctorService
                .getActiveDoctorsByOrganization(organizationId)
                .stream()
                .map(doctorMapper::toResponse)
                .toList();

        return ResponseEntity.ok(doctors);
    }

    @GetMapping("/{doctorId}")
    public ResponseEntity<DoctorResponse> getDoctorById(
            @PathVariable String doctorId,
            @RequestParam String organizationId
    ) {

        Doctor doctor = doctorService.getDoctorById(doctorId, organizationId);
        return ResponseEntity.ok(doctorMapper.toResponse(doctor));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<DoctorResponse> getDoctorByUserId(
            @PathVariable String userId
    ) {

        Doctor doctor = doctorService.getDoctorByUserId(userId);
        return ResponseEntity.ok(doctorMapper.toResponse(doctor));
    }

    @PutMapping("/{doctorId}")
    public ResponseEntity<DoctorResponse> updateDoctor(
            @PathVariable String doctorId,
            @RequestParam String organizationId,
            @Valid @RequestBody DoctorRequest request
    ) {

        Doctor doctor = doctorService.updateDoctor(
                doctorId,
                organizationId,
                doctorMapper.toEntity(request)
        );

        return ResponseEntity.ok(doctorMapper.toResponse(doctor));
    }

    @DeleteMapping("/{doctorId}")
    public ResponseEntity<Void> deactivateDoctor(
            @PathVariable String doctorId,
            @RequestParam String organizationId
    ) {

        doctorService.deactivateDoctor(doctorId, organizationId);
        return ResponseEntity.noContent().build();
    }
}
