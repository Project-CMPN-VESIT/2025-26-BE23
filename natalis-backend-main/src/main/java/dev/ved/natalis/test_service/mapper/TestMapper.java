package dev.ved.natalis.test_service.mapper;

import dev.ved.natalis.test_service.dto.TestListResponse;
import dev.ved.natalis.test_service.dto.TestResponse;
import dev.ved.natalis.test_service.entity.Test;
import dev.ved.natalis.test_service.enums.TestType;
import dev.ved.natalis.test_service.requests.TestRequest;
import org.springframework.stereotype.Component;

import java.time.Instant;

@Component
public class TestMapper {

    public Test toEntity(
            String organizationId,
            String motherId,
            String motherName,
            String doctorId,
            String doctorName,
            TestRequest request
    ) {

        Test test = new Test();

        test.setOrganizationId(organizationId);
        test.setMotherId(motherId);
        test.setMotherName(motherName);
        test.setDoctorId(doctorId);
        test.setDoctorName(doctorName);

        test.setTestType(TestType.AI_ANALYSIS);
        test.setTestTime(Instant.now());

        test.setHcMm(request.getHcMm());
        test.setGaWeeks(request.getGaWeeks());
        test.setClassification(request.getClassification());
        test.setPercentileBand(request.getPercentileBand());
        test.setEdd(request.getEdd());
        test.setTrimester(request.getTrimester());
        test.setWeeksRemaining(request.getWeeksRemaining());
        test.setAnnotatedImageBase64(request.getAnnotatedImageBase64());
        test.setAdditionalResults(request.getAdditionalResults());

        test.setIsActive(true);
        test.setCreatedAt(Instant.now());

        return test;
    }

    public TestResponse toResponse(Test test) {
        return TestResponse.builder()
                .id(test.getId())
                .motherId(test.getMotherId())
                .motherName(test.getMotherName())
                .doctorId(test.getDoctorId())
                .doctorName(test.getDoctorName())
                .organizationId(test.getOrganizationId())
                .testType(test.getTestType())
                .testTime(test.getTestTime())
                .hcMm(test.getHcMm())
                .gaWeeks(test.getGaWeeks())
                .classification(test.getClassification())
                .percentileBand(test.getPercentileBand())
                .edd(test.getEdd())
                .trimester(test.getTrimester())
                .weeksRemaining(test.getWeeksRemaining())
                .annotatedImageBase64(test.getAnnotatedImageBase64())
                .additionalResults(test.getAdditionalResults())
                .build();
    }

    public TestListResponse toListResponse(Test test) {
        return TestListResponse.builder()
                .id(test.getId())
                .motherId(test.getMotherId())
                .motherName(test.getMotherName())
                .doctorName(test.getDoctorName())
                .testType(test.getTestType())
                .testTime(test.getTestTime())
                .classification(test.getClassification())
                .trimester(test.getTrimester())
                .gaWeeks(test.getGaWeeks())
                .build();
    }
}
