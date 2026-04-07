package dev.ved.natalis.test_service.controller;

import dev.ved.natalis.test_service.dto.DashboardStatsResponse;
import dev.ved.natalis.test_service.dto.TestResponse;
import dev.ved.natalis.test_service.dto.TestListResponse;
import dev.ved.natalis.test_service.entity.Test;
import dev.ved.natalis.test_service.mapper.TestMapper;
import dev.ved.natalis.test_service.requests.TestRequest;
import dev.ved.natalis.test_service.service.DashboardService;
import dev.ved.natalis.test_service.service.TestService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("/api/v1/tests")
@RequiredArgsConstructor
public class TestController {

    private final TestService testService;
    private final TestMapper testMapper;
    private final DashboardService dashboardService;

    @PostMapping
    public ResponseEntity<TestResponse> createTest(
            @RequestParam String organizationId,
            @RequestParam String motherId,
            @RequestParam String motherName,
            @RequestParam String doctorId,
            @RequestParam String doctorName,
            @Valid @RequestBody TestRequest request
    ) {

        Test test = testService.createTest(
                organizationId,
                motherName,
                motherId,
                doctorId,
                doctorName,
                request
        );

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(testMapper.toResponse(test));
    }

    @GetMapping("/{testId}")
    public ResponseEntity<TestResponse> getTestById(
            @PathVariable String testId,
            @RequestParam String organizationId
    ) {

        Test test = testService.getTestById(testId, organizationId);
        return ResponseEntity.ok(testMapper.toResponse(test));
    }

    @GetMapping("/by-mother")
    public ResponseEntity<TestResponse> getLatestTestByMother(
            @RequestParam String organizationId,
            @RequestParam String motherId
    ) {

        Test test = testService
                .getLatestTestByMother(organizationId, motherId);

        return ResponseEntity.ok(testMapper.toResponse(test));
    }

    @GetMapping("/list-by-organization")
    public ResponseEntity<List<TestListResponse>> listTestsByOrganization(
            @RequestParam String organizationId,
            @RequestParam(defaultValue = "5") int limit
    ) {

        List<TestListResponse> tests =
                testService.getTestsByOrganization(organizationId, limit)
                        .stream()
                        .map(testMapper::toListResponse)
                        .toList();

        return ResponseEntity.ok(tests);
    }

    @GetMapping("/dashboard")
    public ResponseEntity<DashboardStatsResponse> getDashboardStats(
            @RequestParam String organizationId
    ) {

        return ResponseEntity.ok(
                dashboardService.getDashboardStats(organizationId)
        );
    }

    @DeleteMapping("/{testId}")
    public ResponseEntity<Void> deactivateTest(
            @PathVariable String testId,
            @RequestParam String organizationId
    ) {

        testService.deactivateTest(testId, organizationId);
        return ResponseEntity.noContent().build();
    }
}
