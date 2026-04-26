package dev.ved.natalis.test_service.service;

import dev.ved.natalis.test_service.dto.DashboardStatsResponse;
import dev.ved.natalis.test_service.repository.TestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final TestRepository testRepository;

    public DashboardStatsResponse getDashboardStats(String organizationId) {

        long totalTests =
                testRepository.countByOrganizationId(organizationId);

        Instant now = Instant.now();

        LocalDate today = LocalDate.now(ZoneOffset.UTC);
        Instant startOfToday =
                today.atStartOfDay(ZoneOffset.UTC).toInstant();

        Instant endOfToday =
                startOfToday.plus(1, ChronoUnit.DAYS);

        long testsToday =
                testRepository.countByOrganizationIdAndCreatedAtBetween(
                        organizationId,
                        startOfToday,
                        endOfToday
                );

        LocalDate firstDayOfMonth = today.withDayOfMonth(1);
        Instant startOfMonth =
                firstDayOfMonth.atStartOfDay(ZoneOffset.UTC).toInstant();

        long testsThisMonth =
                testRepository.countByOrganizationIdAndCreatedAtBetween(
                        organizationId,
                        startOfMonth,
                        now
                );

        LocalDate firstDayLastMonth =
                firstDayOfMonth.minusMonths(1);

        Instant startOfLastMonth =
                firstDayLastMonth.atStartOfDay(ZoneOffset.UTC).toInstant();

        long testsLastMonth =
                testRepository.countByOrganizationIdAndCreatedAtBetween(
                        organizationId,
                        startOfLastMonth,
                        startOfMonth
                );

        return new DashboardStatsResponse(
                totalTests,
                testsToday,
                testsThisMonth,
                testsLastMonth
        );
    }
}
