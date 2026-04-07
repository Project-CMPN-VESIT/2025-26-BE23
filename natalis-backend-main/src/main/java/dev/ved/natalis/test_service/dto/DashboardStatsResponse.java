package dev.ved.natalis.test_service.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DashboardStatsResponse {

    private long totalTests;
    private long testsToday;
    private long testsThisMonth;
    private long testsLastMonth;
}