// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';

// import '../services/ScanService.dart';
// import 'add_test_screen.dart';
// import 'scan_result_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   bool _isLoading = false; // 🔥 loading state

//   final ImagePicker _picker = ImagePicker();

//   List<Widget> _buildWidgetOptions(BuildContext context) {
//     final ScanService scanService = ScanService();

//     return <Widget>[
//       // ---------------- HOME TAB ----------------
//       Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Home',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 40),

//             // -------- ADD NEW TEST BUTTON --------
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   PageRouteBuilder(
//                     pageBuilder: (_, animation, __) =>
//                     const AddTestScreen(),
//                     transitionsBuilder: (_, animation, __, child) {
//                       final tween = Tween(
//                         begin: const Offset(0.0, 1.0),
//                         end: Offset.zero,
//                       ).chain(CurveTween(curve: Curves.ease));
//                       return SlideTransition(
//                         position: animation.drive(tween),
//                         child: child,
//                       );
//                     },
//                   ),
//                 );
//               },
//               icon: const FaIcon(FontAwesomeIcons.fileCirclePlus, size: 18),
//               label: const Text('Add New Test'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black12,
//                 shadowColor: Colors.transparent,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 textStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 40),

//             // -------- UPLOAD SCAN BUTTON --------
//             ElevatedButton.icon(
//               onPressed: _isLoading
//                   ? null
//                   : () async {
//                 final XFile? image = await _picker.pickImage(
//                   source: ImageSource.gallery,
//                 );

//                 if (image == null) return;

//                 setState(() => _isLoading = true);

//                 try {
//                   final scanResult =
//                   await scanService.uploadAndAnalyzeScan(
//                     imageFile: File(image.path),
//                     scanDate: DateTime.now(),
//                     race: "Asian & Pacific Islander",
//                     pixelSizeMm: 0.5,
//                   );

//                   if (!context.mounted) return;

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) =>
//                           ScanResultScreen(result: scanResult),
//                     ),
//                   );
//                 } catch (e) {
//                   debugPrint("Scan upload failed: $e");

//                   if (mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Upload failed'),
//                       ),
//                     );
//                   }
//                 } finally {
//                   if (mounted) {
//                     setState(() => _isLoading = false);
//                   }
//                 }
//               },
//               icon: _isLoading
//                   ? const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.black,
//                 ),
//               )
//                   : const FaIcon(FontAwesomeIcons.upload, size: 18),
//               label: Text(
//                 _isLoading ? 'Analyzing Scan...' : 'Upload Scan',
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black12,
//                 shadowColor: Colors.transparent,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 textStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),

//       // ---------------- PATIENTS TAB ----------------
//       const Center(
//         child: Text(
//           'Patients',
//           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//         ),
//       ),

//       // ---------------- PROFILE TAB ----------------
//       const Center(
//         child: Text(
//           'Profile',
//           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//         ),
//       ),
//     ];
//   }

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final widgetOptions = _buildWidgetOptions(context);

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text('Natalis (Dev)'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const CircleAvatar(
//               radius: 16,
//               child: Icon(Icons.person, size: 20),
//             ),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 12),
//         ],
//       ),
//       body: widgetOptions[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Theme.of(context).primaryColor,
//         items: const [
//           BottomNavigationBarItem(
//             icon: FaIcon(FontAwesomeIcons.houseMedical),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: FaIcon(FontAwesomeIcons.users),
//             label: 'Patients',
//           ),
//           BottomNavigationBarItem(
//             icon: FaIcon(FontAwesomeIcons.solidUserCircle),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
