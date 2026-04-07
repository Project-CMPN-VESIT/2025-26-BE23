package dev.ved.natalis.mother_service.service;

import dev.ved.natalis.exception.BadRequestException;
import dev.ved.natalis.exception.ResourceNotFoundException;
import dev.ved.natalis.mother_service.entity.Mother;
import dev.ved.natalis.mother_service.mapper.MotherMapper;
import dev.ved.natalis.mother_service.repository.MotherRepository;
import dev.ved.natalis.mother_service.requests.MotherRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.regex.Pattern;
@Service
@RequiredArgsConstructor
public class MotherService {

    private final MotherRepository motherRepository;
    private final MotherMapper motherMapper;

    public Mother createMother(
            String organizationId,
            String doctorId,
            String userId,
            MotherRequest request
    ) {

        if (userId != null && motherRepository.existsByUserId(userId)) {
            throw new BadRequestException(
                    "Mother profile already exists for this user"
            );
        }

        Mother mother = motherMapper.toEntity(
                request,
                organizationId,
                doctorId,
                userId
        );

        mother.setEdd(calculateEdd(request.getLmp()));

        return motherRepository.save(mother);
    }

    public Mother getMotherById(
            String motherId,
            String organizationId
    ) {
        return motherRepository
                .findByIdAndOrganizationId(motherId, organizationId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Mother not found"));
    }

    public List<Mother> getActiveMothersByOrganization(
            String organizationId
    ) {
        return motherRepository
                .findByOrganizationIdAndIsActiveTrue(organizationId);
    }

    public List<Mother> getActiveMothersByDoctor(
            String organizationId,
            String doctorId
    ) {
        return motherRepository
                .findByOrganizationIdAndDoctorIdAndIsActiveTrue(
                        organizationId, doctorId
                );
    }

    public Mother getMotherByUserId(String userId) {
        return motherRepository
                .findByUserId(userId)
                .orElseThrow(() ->
                        new ResourceNotFoundException(
                                "Mother not found for user"));
    }

    public Mother updateMother(
            String motherId,
            String organizationId,
            MotherRequest request
    ) {

        Mother mother = getMotherById(motherId, organizationId);

        mother.setName(request.getName());
        mother.setAge(request.getAge());
        mother.setMaritalStatus(request.getMaritalStatus());
        mother.setBloodGroup(request.getBloodGroup());
        mother.setGravida(request.getGravida());
        mother.setPara(request.getPara());
        mother.setHighRisk(
                request.getHighRisk() != null ? request.getHighRisk() : false
        );
        mother.setAdditionalMedicalInfo(
                request.getAdditionalMedicalInfo()
        );

        if (request.getLmp() != null &&
                !request.getLmp().equals(mother.getLmp())) {

            mother.setLmp(request.getLmp());
            mother.setEdd(calculateEdd(request.getLmp()));
        }

        return motherRepository.save(mother);
    }

    public List<Mother> searchMothersByName(
            String organizationId,
            String name
    ) {

        String regex = ".*" + Pattern.quote(name) + ".*";

        return motherRepository
                .findByOrganizationIdAndNameRegexIgnoreCaseAndIsActiveTrue(
                        organizationId, regex
                );
    }

    public void deactivateMother(
            String motherId,
            String organizationId
    ) {

        Mother mother = getMotherById(motherId, organizationId);

        mother.setIsActive(false);

        motherRepository.save(mother);
    }

    private LocalDate calculateEdd(LocalDate lmp) {
        return lmp.plusWeeks(40);
    }
}
