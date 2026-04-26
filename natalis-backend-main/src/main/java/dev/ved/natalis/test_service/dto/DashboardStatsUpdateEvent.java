package dev.ved.natalis.test_service.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DashboardStatsUpdateEvent {

    private long totalTestsIncrement;
    private long testsTodayIncrement;
    private long testsThisMonthIncrement;
}