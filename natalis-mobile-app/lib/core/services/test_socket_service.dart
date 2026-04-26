import 'dart:async';
import 'dart:convert';
import 'package:natalis_frontend/models/dashboard_stats_update_event.dart';
import 'package:natalis_frontend/models/test-small.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

//  url: 'ws://192.168.0.109:8080/ws',
/// 'wss://natalis-backend.onrender.com/ws'
class TestSocketService {
  late StompClient _client;

  final _testController = StreamController<TestListItem>.broadcast();
  final _dashboardController =
      StreamController<DashboardStatsUpdateEvent>.broadcast();

  Stream<TestListItem> get testStream => _testController.stream;
  Stream<DashboardStatsUpdateEvent> get dashboardStream =>
      _dashboardController.stream;

  void connect({required String organizationId}) {
    _client = StompClient(
      config: StompConfig(
        url: 'wss://natalis-backend.onrender.com/ws',
        onConnect: (_) {
          _subscribeTests(organizationId);
          _subscribeDashboard(organizationId);
        },
        onWebSocketError: (error) {
          print("WebSocket error: $error");
        },
      ),
    );

    _client.activate();
  }

  void _subscribeTests(String organizationId) {
    _client.subscribe(
      destination: '/topic/org/$organizationId/tests',
      callback: (frame) {
        if (frame.body != null) {
          final json = jsonDecode(frame.body!);
          final test = TestListItem.fromJson(json);
          _testController.add(test);
        }
      },
    );
  }

  void _subscribeDashboard(String organizationId) {
    _client.subscribe(
      destination: '/topic/org/$organizationId/dashboard',
      callback: (frame) {
        if (frame.body != null) {
          final json = jsonDecode(frame.body!);
          final event = DashboardStatsUpdateEvent.fromJson(json);
          _dashboardController.add(event);
        }
      },
    );
  }

  void disconnect() {
    _client.deactivate();
    _testController.close();
    _dashboardController.close();
  }
}
