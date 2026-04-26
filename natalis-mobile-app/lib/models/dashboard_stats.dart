class DashboardStats {
  final int totalTests;
  final int testsToday;
  final int testsThisMonth;
  final int testsLastMonth;

  const DashboardStats({
    required this.totalTests,
    required this.testsToday,
    required this.testsThisMonth,
    required this.testsLastMonth,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalTests: json['totalTests'] ?? 0,
      testsToday: json['testsToday'] ?? 0,
      testsThisMonth: json['testsThisMonth'] ?? 0,
      testsLastMonth: json['testsLastMonth'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTests': totalTests,
      'testsToday': testsToday,
      'testsThisMonth': testsThisMonth,
      'testsLastMonth': testsLastMonth,
    };
  }

  DashboardStats copyWith({
    int? totalTests,
    int? testsToday,
    int? testsThisMonth,
    int? testsLastMonth,
  }) {
    return DashboardStats(
      totalTests: totalTests ?? this.totalTests,
      testsToday: testsToday ?? this.testsToday,
      testsThisMonth: testsThisMonth ?? this.testsThisMonth,
      testsLastMonth: testsLastMonth ?? this.testsLastMonth,
    );
  }

  double get monthlyGrowthPercentage {
    if (testsLastMonth == 0) return 0;
    return ((testsThisMonth - testsLastMonth) / testsLastMonth) * 100;
  }
}
