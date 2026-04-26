// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:natalis_frontend/models/test.dart';

// import '../../../models/scan_result.dart';
// import '../../../models/test-small.dart';
// import '../repository/test_repository.dart';

// class TestService {
//   final TestRepository _repository;

//   TestService() : _repository = TestRepository();

//   /* =========================
//      CREATE TEST
//      ========================= */

//   // Future<void> createTest({
//   //   required String organizationId,
//   //   required String motherId,
//   //   required String motherName,
//   //   required String doctorId,
//   //   required ScanResult scanResult,
//   // }) async {
//   //   try {
//   //     await _repository.createTest(
//   //       organizationId: organizationId,
//   //       motherId: motherId,
//   //       motherName: motherName,
//   //       doctorId: doctorId,
//   //       scanResult: scanResult,
//   //     );
//   //   } catch (e) {
//   //     throw Exception("Test creation failed: $e");
//   //   }
//   // }

//   /* =========================
//      LIST TESTS BY DOCTOR
//      ========================= */

//   Future<List<TestListItem>> listTestsByDoctor({
//     required String organizationId,
//     required String doctorId,
//   }) async {
//     try {
//       return await _repository.listTestsByDoctor(
//         organizationId: organizationId,
//         doctorId: doctorId,
//       );
//     } catch (e) {
//       throw Exception("Fetching tests by doctor failed: $e");
//     }
//   }

//   /* =========================
//      GET SINGLE (LATEST) TEST BY MOTHER
//      ========================= */

//   Future<TestModel> getTestByMother({
//     required String organizationId,
//     required String motherId,
//   }) async {
//     try {
//       return await _repository.getTestByMother(
//         organizationId: organizationId,
//         motherId: motherId,
//       );
//     } catch (e) {
//       throw Exception("Fetching test by mother failed: $e");
//     }
//   }
// }
