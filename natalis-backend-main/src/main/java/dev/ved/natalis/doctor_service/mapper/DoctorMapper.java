package dev.ved.natalis.doctor_service.mapper;

import dev.ved.natalis.doctor_service.dto.DoctorResponse;
import dev.ved.natalis.doctor_service.entity.Doctor;
import dev.ved.natalis.doctor_service.requests.DoctorRequest;
import org.springframework.stereotype.Component;

@Component
public class DoctorMapper {

    public Doctor toEntity(DoctorRequest request) {

        Doctor doctor = new Doctor();
        doctor.setName(request.getName());
        doctor.setSpecialization(request.getSpecialization());
        doctor.setQualification(request.getQualification());
        doctor.setExperienceYears(request.getExperienceYears());

        return doctor;
    }

    public DoctorResponse toResponse(Doctor doctor) {

        return DoctorResponse.builder()
                .id(doctor.getId())
                .name(doctor.getName())
                .specialization(doctor.getSpecialization())
                .qualification(doctor.getQualification())
                .experienceYears(doctor.getExperienceYears())
                .organizationName(doctor.getOrganizationName())
                .organizationId(doctor.getOrganizationId())
                .build();
    }
}
