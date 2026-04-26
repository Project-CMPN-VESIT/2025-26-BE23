class DashboardStatsUpdateEvent {
  final int totalTestsIncrement;
  final int testsTodayIncrement;
  final int testsThisMonthIncrement;

  DashboardStatsUpdateEvent({
    required this.totalTestsIncrement,
    required this.testsTodayIncrement,
    required this.testsThisMonthIncrement,
  });

  factory DashboardStatsUpdateEvent.fromJson(Map<String, dynamic> json) {
    return DashboardStatsUpdateEvent(
      totalTestsIncrement: json['totalTestsIncrement'] ?? 0,
      testsTodayIncrement: json['testsTodayIncrement'] ?? 0,
      testsThisMonthIncrement: json['testsThisMonthIncrement'] ?? 0,
    );
  }
}
