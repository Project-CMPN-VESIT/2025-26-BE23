package dev.ved.natalis.test_service.service;

import dev.ved.natalis.exception.ResourceNotFoundException;
import dev.ved.natalis.test_service.dto.DashboardStatsResponse;
import dev.ved.natalis.test_service.dto.DashboardStatsUpdateEvent;
import dev.ved.natalis.test_service.dto.TestListResponse;
import dev.ved.natalis.test_service.entity.Test;
import dev.ved.natalis.test_service.enums.TestType;
import dev.ved.natalis.test_service.mapper.TestMapper;
import dev.ved.natalis.test_service.repository.TestRepository;
import dev.ved.natalis.test_service.requests.TestRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.NoSuchElementException;
@Service
@RequiredArgsConstructor
public class TestService {

    private final TestRepository testRepository;
    private final SimpMessagingTemplate messagingTemplate;
    private final TestMapper testMapper;

    public Test createTest(
            String organizationId,
            String motherName,
            String motherId,
            String doctorId,
            String doctorName,
            TestRequest request
    ) {

        Test test = testMapper.toEntity(
                organizationId,
                motherId,
                motherName,
                doctorId,
                doctorName,
                request
        );

        Test savedTest = testRepository.save(test);

        // Broadcast
        messagingTemplate.convertAndSend(
                "/topic/org/" + organizationId + "/tests",
                testMapper.toListResponse(savedTest)
        );
        messagingTemplate.convertAndSend(
                "/topic/org/" + organizationId + "/dashboard",
                new DashboardStatsUpdateEvent(
                        1, // totalTests
                        1, // today
                        1  // thisMonth
                )
        );


        return savedTest;
    }

    public Test getTestById(String testId, String organizationId) {
        return testRepository
                .findByIdAndOrganizationId(testId, organizationId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("Test not found"));
    }

    public Test getLatestTestByMother(
            String organizationId,
            String motherId
    ) {
        return testRepository
                .findTopByOrganizationIdAndMotherIdAndIsActiveTrueOrderByTestTimeDesc(
                        organizationId, motherId)
                .orElseThrow(() ->
                        new ResourceNotFoundException("No test found for mother"));
    }

    public List<Test> getTestsByDoctor(
            String organizationId,
            String doctorId
    ) {
        return testRepository
                .findByOrganizationIdAndDoctorIdAndIsActiveTrueOrderByTestTimeDesc(
                        organizationId, doctorId);
    }

    public List<Test> getTestsByOrganization(
            String organizationId,
            int limit
    ) {
        Pageable pageable = PageRequest.of(
                0,
                limit,
                Sort.by(Sort.Direction.DESC, "createdAt")
        );

        return testRepository
                .findByOrganizationId(organizationId, pageable)
                .getContent();
    }

    public void deactivateTest(
            String testId,
            String organizationId
    ) {
        Test test = getTestById(testId, organizationId);
        test.setIsActive(false);
        testRepository.save(test);
    }
}
