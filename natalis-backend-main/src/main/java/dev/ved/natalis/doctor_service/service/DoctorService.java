package dev.ved.natalis.doctor_service.service;
import dev.ved.natalis.doctor_service.entity.Doctor;
import dev.ved.natalis.doctor_service.repository.DoctorRepository;
import dev.ved.natalis.exception.BadRequestException;
import dev.ved.natalis.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.regex.Pattern;
@Service
@RequiredArgsConstructor
public class DoctorService {

    private final DoctorRepository doctorRepository;

    public Doctor createDoctor(
            String userId,
            String organizationId,
            String organizationName,
            Doctor doctorRequest
    ) {

        if (doctorRepository.existsByUserId(userId)) {
            throw new BadRequestException(
                    "Doctor profile already exists for this user");
        }

        Doctor doctor = new Doctor();
        doctor.setUserId(userId);
        doctor.setName(doctorRequest.getName());
        doctor.setSpecialization(doctorRequest.getSpecialization());
        doctor.setQualification(doctorRequest.getQualification());
        doctor.setExperienceYears(doctorRequest.getExperienceYears());
        doctor.setOrganizationId(organizationId);
        doctor.setOrganizationName(organizationName);
        doctor.setIsActive(true);
        doctor.setCreatedAt(Instant.now());

        return doctorRepository.save(doctor);
    }

    public List<Doctor> getActiveDoctorsByOrganization(String organizationId) {
        return doctorRepository
                .findByOrganizationIdAndIsActiveTrue(organizationId);
    }

    public Doctor getDoctorById(
            String doctorId,
            String organizationId
    ) {
        return doctorRepository
                .findByIdAndOrganizationId(doctorId, organizationId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Doctor not found"));
    }

    public Doctor getDoctorByUserId(String userId) {
        return doctorRepository
                .findByUserId(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Doctor profile not found"));
    }

    public Doctor updateDoctor(
            String doctorId,
            String organizationId,
            Doctor updatedDoctor
    ) {

        Doctor existingDoctor = getDoctorById(doctorId, organizationId);

        existingDoctor.setName(updatedDoctor.getName());
        existingDoctor.setSpecialization(updatedDoctor.getSpecialization());
        existingDoctor.setQualification(updatedDoctor.getQualification());
        existingDoctor.setExperienceYears(updatedDoctor.getExperienceYears());

        return doctorRepository.save(existingDoctor);
    }

    public void deactivateDoctor(
            String doctorId,
            String organizationId
    ) {
        Doctor doctor = getDoctorById(doctorId, organizationId);
        doctor.setIsActive(false);
        doctorRepository.save(doctor);
    }
}
