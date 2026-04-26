// import 'package:flutter/material.dart';

// class AddTestScreen extends StatefulWidget {
//   const AddTestScreen({super.key});

//   @override
//   State<AddTestScreen> createState() => _AddTestScreenState();
// }

// class _AddTestScreenState extends State<AddTestScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _detail1Controller = TextEditingController();
//   final TextEditingController _detail2Controller = TextEditingController();

//   @override
//   void dispose() {
//     // Clean up the controllers when the widget is disposed.
//     _detail1Controller.dispose();
//     _detail2Controller.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     // Validate returns true if the form is valid, or false otherwise.
//     if (_formKey.currentState!.validate()) {
//       // If the form is valid, process the data.
//       final detail1 = _detail1Controller.text;
//       final detail2 = _detail2Controller.text;

//       print('Form submitted successfully!');
//       print('Detail 1: $detail1');
//       print('Detail 2: $detail2');

//       // TODO: Call your repository to save the data

//       // Show a confirmation snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('New test saved!')),
//       );

//       // Go back to the previous screen
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add New Test'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextFormField(
//                 controller: _detail1Controller,
//                 decoration: const InputDecoration(
//                   labelText: 'Test Detail 1',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter detail 1';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               TextFormField(
//                 controller: _detail2Controller,
//                 decoration: const InputDecoration(
//                   labelText: 'Test Detail 2',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter detail 2';
//                   }
//                   return null;
//                 },
//               ),
//               const Spacer(), // Pushes the button to the bottom
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   textStyle: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 child: const Text('Done'),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
