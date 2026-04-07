package dev.ved.natalis.mother_service.mapper;

import dev.ved.natalis.mother_service.dto.MotherResponse;
import dev.ved.natalis.mother_service.entity.Mother;
import dev.ved.natalis.mother_service.requests.MotherRequest;
import org.springframework.stereotype.Component;

import java.time.Instant;

@Component
public class MotherMapper {

    public Mother toEntity(
            MotherRequest request,
            String organizationId,
            String doctorId,
            String userId
    ) {

        Mother mother = new Mother();

        mother.setName(request.getName());
        mother.setAge(request.getAge());
        mother.setMaritalStatus(request.getMaritalStatus());
        mother.setBloodGroup(request.getBloodGroup());
        mother.setLmp(request.getLmp());
        mother.setGravida(request.getGravida());
        mother.setPara(request.getPara());
        mother.setHighRisk(
                request.getHighRisk() != null ? request.getHighRisk() : false
        );
        mother.setAdditionalMedicalInfo(
                request.getAdditionalMedicalInfo()
        );

        mother.setOrganizationId(organizationId);
        mother.setDoctorId(doctorId);
        mother.setUserId(userId);

        mother.setIsActive(true);
        mother.setCreatedAt(Instant.now());

        return mother;
    }

    public MotherResponse toResponse(Mother mother) {
        return MotherResponse.builder()
                .id(mother.getId())
                .name(mother.getName())
                .age(mother.getAge())
                .maritalStatus(mother.getMaritalStatus())
                .bloodGroup(mother.getBloodGroup())
                .lmp(mother.getLmp())
                .edd(mother.getEdd())
                .gravida(mother.getGravida())
                .para(mother.getPara())
                .highRisk(mother.getHighRisk())
                .doctorId(mother.getDoctorId())
                .organizationId(mother.getOrganizationId())
                .build();
    }
}
